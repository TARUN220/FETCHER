//
//  ZMailAPIManager.swift
//  ZMail
//
//  Created by siva-6975 on 08/12/19.
//

import Foundation

//public enum ZAPIIdentifier: String {
//
//}

public class ZAPIManager {
    
    public typealias ZAPIIdentifier = String
    
    private let httpNetwork: ZHTTPNetworkContract
    private init(httpNetwork: ZHTTPNetworkContract) {
        self.httpNetwork = httpNetwork
    }
    
    private static var _shared: ZAPIManager!

    public static func shared(httpNetwork: ZHTTPNetworkContract) -> ZAPIManager {
        if let _ = _shared {
            return _shared!
        }
        _shared = ZAPIManager(httpNetwork: httpNetwork)
        return _shared!
    }
    
    private var apiControllers: [ZAPICallController] = []
    
    public func isAPIRegistered(with identifier: ZAPIIdentifier) -> Bool {
        return getAPIController(identifier: identifier) != nil
    }
    
    public func registerAPI(threshold: Int, callType: ZAPICallController.RequestCallType, identifier: ZAPIIdentifier) {
        guard !isAPIRegistered(with: identifier) else {
            return
        }
        
        let apiController = ZAPICallController(threshold: threshold, callType: callType, httpNetwork: httpNetwork, identifier: identifier)
        apiControllers.append(apiController)
    }
    
    public func addRequest(request: ZHTTP.Request, requestIdentifier: String? = nil, addAtBottom: Bool = false, apiIdentifier: ZAPIIdentifier, progressPercentageHandler: ((_ progress: Float, _ totalBytesWritten: Int64, _ totalBytesExpectedToWrite:Int64,  _ identifier: String?, _ taskId: Int) -> ())? = nil, progressHandler: ((Data, Double, String?, _ taskId: Int) -> ())? = nil, taskInfoHandler: ZHTTP.TaskInfoHandler? = nil, fileUploadInfos: [ZHTTP.FileUploadInfo]? = nil, callback: @escaping ZHTTP.CompletionHandler) {
        
        getAPIController(identifier: apiIdentifier)?.addRequest(request: request, requestIdentifier: requestIdentifier, addAtBottom: addAtBottom, progressPercentageHandler: progressPercentageHandler, progressHandler: progressHandler, taskInfoHandler: taskInfoHandler, fileUploadInfos: fileUploadInfos, callback: callback)
    }
    
    public func cancel(requestIdentifier: String, apiIdentifier: ZAPIIdentifier) -> Bool {
        return getAPIController(identifier: apiIdentifier)?.cancel(requestIdentifier: requestIdentifier) ?? false
    }
    
    public func cancel(taskId: Int, apiIdentifier: ZAPIIdentifier) -> Bool {
       return getAPIController(identifier: apiIdentifier)?.cancel(taskId: taskId) ?? false
    }
    
    private func getAPIController(identifier: ZAPIIdentifier) -> ZAPICallController? {
        if let apiController = apiControllers.filter({$0.identifier == identifier}).first {
            return apiController
        }
        return nil
    }
    
    public func cancelAllRequests(apiIdentifier: ZAPIIdentifier? = nil) {
        if let id = apiIdentifier {
            getAPIController(identifier: id)?.cancelAllRequests()
            return
        }
        apiControllers.forEach({$0.cancelAllRequests()})
    }
}
