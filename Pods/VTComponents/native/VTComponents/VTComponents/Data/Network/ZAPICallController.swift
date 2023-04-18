//
//  ZMailAPICallController.swift
//  ZMail
//
//  Created by siva-6975 on 06/12/19.
//

import Foundation

public class ZAPICallController {
    
    private var threshold: Int                       //The threshold value of the API to avoid IP Lock
    private var callType: RequestCallType
    let identifier: ZAPIManager.ZAPIIdentifier
    private var httpNetwork: ZHTTPNetworkContract
    private var thresholdTimeInterval: TimeInterval = 60
    private var thresholdCounter: Int
    
    private let queue = DispatchQueue(label: "APIControllerQueue")
    
    fileprivate class RequestData {
        
        fileprivate var identifier: String?
        fileprivate var taskId: Int?
        var request: ZHTTP.Request
        var progressPercentageHandler: ((_ progress: Float, _ totalBytesWritten: Int64, _ totalBytesExpectedToWrite:Int64,  _ identifier: String?, _ taskId: Int) -> ())?
        var progressHandler: ((Data, Double, String?, _ taskId: Int) -> ())?
        var fileUploadInfos: [ZHTTP.FileUploadInfo]?
        var taskInfoHandler: ZHTTP.TaskInfoHandler?
        var callback: ZHTTP.CompletionHandler
        
        init(request: ZHTTP.Request, callback: @escaping ZHTTP.CompletionHandler, identifier: String? = nil) {
            self.request = request
            self.callback = callback
            self.identifier = identifier
        }
    }
    
    public enum RequestCallType {
        case normal, download, upload
    }
    
    private var executingTaskIds: [Int] = []
    private var submittedTaskIds: [Int] = []
    
    private var apiStack: ZStack<RequestData> = ZStack<RequestData>()
    
    //Logger
    private let logger = Logger()
    
    init(threshold: Int, thresholdTimeInterval: TimeInterval = 60, callType: RequestCallType, httpNetwork: ZHTTPNetworkContract, identifier: ZAPIManager.ZAPIIdentifier) {
        self.threshold = threshold
        self.callType = callType
        self.identifier = identifier
        self.httpNetwork = httpNetwork
        self.thresholdCounter = threshold
        self.thresholdTimeInterval = thresholdTimeInterval
        
        let value = ZUserDefaults.double(key: self.identifier)
        let diff = value + self.thresholdTimeInterval - Date().timeIntervalSince1970
        if diff > 0 {
            self.thresholdCounter = 0
            logger.log("Blocked.. \(identifier) api for \(diff + 1) seconds")
            self.queue.asyncAfter(deadline: .now() + diff) {
                self.executeRequests()
            }
        }
    }
    
    
    func addRequest(request: ZHTTP.Request, requestIdentifier: String? = nil, addAtBottom: Bool = false, progressPercentageHandler: ((_ progress: Float, _ totalBytesWritten: Int64, _ totalBytesExpectedToWrite:Int64,  _ identifier: String?, _ taskId: Int) -> ())? = nil, progressHandler: ((Data, Double, String?, _ taskId: Int) -> ())? = nil, taskInfoHandler: ZHTTP.TaskInfoHandler? = nil, fileUploadInfos: [ZHTTP.FileUploadInfo]? = nil, callback: @escaping ZHTTP.CompletionHandler ) {
        queue.async {
        self.logger.log("Request: \(String(describing: request.identifier))")
        let executionObject = RequestData(request: request, callback: callback)
        executionObject.identifier = requestIdentifier ?? "\(Date().timeIntervalSince1970)"
        executionObject.progressHandler = progressHandler
        executionObject.progressPercentageHandler = progressPercentageHandler
        executionObject.taskInfoHandler = taskInfoHandler
        executionObject.fileUploadInfos = fileUploadInfos
        
        var requestAlreadyPresent = false
        if let reqId = requestIdentifier, let reqData = self.apiStack.allElements.first(where: {$0.identifier == reqId}) {
            requestAlreadyPresent = true
            self.logger.log("Removing \(reqId) from queue")
            self.apiStack.remove(element: reqData)
        }
        if addAtBottom && !requestAlreadyPresent {
            self.apiStack.addAtBottom(executionObject)
            self.logger.log("At bottom: \(requestIdentifier ?? "")")
        }
        else {
            self.logger.log("Pushed: \(requestIdentifier ?? "")")
            self.apiStack.push(executionObject)
        }
        
        self.executeRequestsIfAvailable()
        }
    }
    
    func cancel(taskId: Int) -> Bool {
        logger.log("Cancel: \(taskId)")
        queue.async {
            if self.executingTaskIds.contains(taskId) {
                self.httpNetwork.cancel(taskId: taskId)
                self.executingTaskIds.removeAll(where: {$0 == taskId})
                self.logger.log("Canceled after starting \(taskId): \(self.thresholdCounter)")
            }
            else if self.submittedTaskIds.contains(taskId) {
                self.httpNetwork.cancel(taskId: taskId)
                self.incrementThresholdCounterAfterDelay(taskId)
                self.logger.log("Canceled before starting \(taskId): \(self.thresholdCounter)")
            }
        }
        return false
    }
    
    func cancel(requestIdentifier: String) -> Bool {
        logger.log("Cancel: \(requestIdentifier)")
        if let request = apiStack.allElements.filter({$0.request.identifier == requestIdentifier}).first {
            queue.async {
                if let taskId = request.taskId {
                    _ = self.cancel(taskId: taskId)
                }
                self.apiStack.remove(element: request)
            }
            return true
        }
        return false
    }
    
    func cancelAllRequests() {
        queue.async {
            self.apiStack.popAll()
            for taskId in self.executingTaskIds {
                self.httpNetwork.cancel(taskId: taskId)
            }
            self.executingTaskIds = []
        }
    }
    
    @objc
    private func executeRequests() {
        self.logger.log("Released \(identifier) api")
        self.thresholdCounter = threshold
        executeRequestsIfAvailable()
    }
    
    private func executeRequestsIfAvailable() {
        queue.async {
            if self.canExecuteRequest(), let request = self.apiStack.pop() {
                self.execute(requestData: request)
            }
        }
    }
    
    private func execute(requestData: RequestData) {
        self.logger.log("Executing: \(requestData.identifier ?? "")")
        switch self.callType {
        case .download:
            self.httpNetwork.download(request: requestData.request,
                                    requestDidStartHandler: { taskId in
                                      self.logger.log("calling Increment from start...\(taskId).. \(self.thresholdCounter)")
                                      self.incrementThresholdCounterAfterDelay(taskId)
                                      self.executingTaskIds.append(taskId)
          }, progressPercentageHandler: requestData.progressPercentageHandler, progressHandler: requestData.progressHandler, taskInfoHandler: { taskId in
              requestData.taskId = taskId
              self.submittedTaskIds.append(taskId)
              requestData.taskInfoHandler?(taskId)
          }, completionHandler: { response in
              self.executingTaskIds.removeAll(where: {$0 == response.taskId})
              requestData.callback(response)
              })
          self.logger.log("decrementing before... \(self.thresholdCounter)")
          self.thresholdCounter -= 1
          self.logger.log("decrementing after... \(self.thresholdCounter)")
        case .normal:
          self.httpNetwork.send(request: requestData.request, requestDidStartHandler: { (taskId) in
              self.logger.log("calling Increment from start...\(taskId).. \(self.thresholdCounter)")
              self.incrementThresholdCounterAfterDelay(taskId)
              self.executingTaskIds.append(taskId)
          }, requestRedirectionHandler: nil, taskInfoHandler: { taskId in
                requestData.taskId = taskId
                requestData.taskInfoHandler?(taskId)
                self.submittedTaskIds.append(taskId)
           }, completionHandler: { response in
              self.executingTaskIds.removeAll(where: {$0 == response.taskId})
               requestData.callback(response)
           })
           self.thresholdCounter -= 1
        case .upload:
            self.httpNetwork.upload(request: requestData.request, fileInfos: requestData.fileUploadInfos ?? [], requestDidStartHandler: { (taskId) in
                self.logger.log("calling Increment from start...\(taskId).. \(self.thresholdCounter)")
                self.incrementThresholdCounterAfterDelay(taskId)
                self.executingTaskIds.append(taskId)
            }, progressDataHandler: requestData.progressHandler, progressPercentageHandler: requestData.progressPercentageHandler, taskInfoHandler: { taskId in
                requestData.taskId = taskId
                requestData.taskInfoHandler?(taskId)
                self.submittedTaskIds.append(taskId)
            }, completionHandler: { response in
              self.executingTaskIds.removeAll(where: {$0 == response.taskId})
                requestData.callback(response)
            })
            self.thresholdCounter -= 1
        }
    }
    //MARK:- Utilities
    
    func canExecuteRequest() -> Bool {
        self.logger.log("thresholdCounter: \(self.thresholdCounter) executingTasksCount: \(self.executingTaskIds.count) submitted: \(self.submittedTaskIds.count)")
        if self.thresholdCounter > 0 {
            self.logger.log("allowed...")
            return true
        }
        self.logger.log("blocked...thresholdCounter: \(self.thresholdCounter)....")
        return false
    }
    
    func incrementThresholdCounterAfterDelay(_ taskId: Int) {
        self.logger.log("called incrementing...\(taskId) \(self.thresholdCounter)")
        
        ZUserDefaults.setDouble(value: Date().timeIntervalSince1970, key: self.identifier)
        
        queue.asyncAfter(deadline: .now() + thresholdTimeInterval) {
            if self.submittedTaskIds.contains(taskId) {
                self.thresholdCounter += 1
                self.submittedTaskIds.removeAll(where: {$0 == taskId})
                self.executeRequestsIfAvailable()
                self.logger.log("incrementing... \(self.thresholdCounter)")
            }
        }
    }
}

extension ZAPICallController.RequestData: Equatable {
    static func == (lhs: ZAPICallController.RequestData, rhs: ZAPICallController.RequestData) -> Bool {
        if let leftId = lhs.identifier, let rightId = rhs.identifier, leftId == rightId {
            return true
        }
        return false
    }
}

