//
//  ZDataSyncer.swift
//  ZohoMail
//
//  Created by Rahul T on 31/07/17.
//  Copyright © 2017 Zoho Corporation. All rights reserved.
//

import Foundation

//This class is used to sync ordered list

public enum ZSyncOperationType {
    case add
    case update
    case delete
}

open class ZDataSyncer<T:Comparable> {
    
    //MARK:- public methods
    
    open class func sync(localData: [T], serverData: [T], startIndex: Int = 0, addHandler: (_ data:T,_ index: Int) -> Void, removeHandler: (_ data:T,_ index: Int) -> Void, updateHandler: (_ data:T,_ index: Int) -> Void) {
        //dlog("Local : \(localData) --- server: \(serverData)", tag: "ZDataSyncer", flag: ZLogger.Flag.verbose)
        var local: [T] = localData
        var j = startIndex
        var add = false
        var i = 0
        while (i < serverData.count) {
            let serverDetail = serverData[i]
            var localDetail: T!
            if j == local.count {
                j = local.count
                add = true
            }
            else {
                localDetail = local[j]
            }
            if add || (serverDetail > localDetail) {
                //dlog("add : \(serverDetail) at \(j)", tag: "ZDataSyncer", flag: ZLogger.Flag.verbose)
                addHandler(serverDetail, j)
                local.insert(serverDetail, at: j)
                i = i + 1
                j = j + 1
            }
            else if serverDetail < localDetail {
                //dlog("remove : \(serverDetail) at \(j)", tag: "ZDataSyncer", flag: ZLogger.Flag.verbose)
                removeHandler(localDetail, j)
                local.remove(at: j)
            }
            else if serverDetail == localDetail {
                //dlog("update : \(serverDetail) at \(j)", tag: "ZDataSyncer", flag: ZLogger.Flag.verbose)
                updateHandler(serverDetail, j)
                local[j] = serverDetail
                i = i + 1
                j = j + 1
            }
            else if serverDetail != localDetail {
                //dlog("remove != : \(serverDetail) at \(j)", tag: "ZDataSyncer", flag: ZLogger.Flag.verbose)
                removeHandler(localDetail, j)
                local.remove(at: j)
            }
        }
        
        while j < local.count {
            //dlog("removeTail : \(local[j]) at \(j)", tag: "ZDataSyncer", flag: ZLogger.Flag.verbose)
            removeHandler(local[j],j)
            local.remove(at: j)
        }
    }
    
    open class func sync(localData: [T], serverData: [T], startIndex: Int = 0) -> (updatedData: [T], syncResult: [(operation: ZSyncOperationType, indexCollection: [Int])]) {
        var local: [T] = localData
        var j = startIndex
        var add = false
        var i = 0
        
        var currentIndexCollection: [Int] = []
        var previousOperationType: ZSyncOperationType = .add
        var syncResult: [(operation: ZSyncOperationType, indexCollection: [Int])] = []
        
        while (i < serverData.count) {
            let serverDetail = serverData[i]
            var localDetail: T!
            if j == local.count {
                j = local.count
                add = true
            }
            else {
                localDetail = local[j]
            }
            
            if add || (serverDetail > localDetail) {
                local.insert(serverDetail, at: j)
                addSync(index: j, operationType: .add, currentIndexCollection: &currentIndexCollection, syncResult: &syncResult, previousOperationType: &previousOperationType)
                i = i + 1
                j = j + 1
            }
            else if serverDetail < localDetail {
                local.remove(at: j)
                addSync(index: j, operationType: .delete, currentIndexCollection: &currentIndexCollection, syncResult: &syncResult, previousOperationType: &previousOperationType)
            }
            else if serverDetail == localDetail {
                local[j] = serverDetail
                addSync(index: j, operationType: .update, currentIndexCollection: &currentIndexCollection, syncResult: &syncResult, previousOperationType: &previousOperationType)
                i = i + 1
                j = j + 1
            }
            else if serverDetail != localDetail {
                local.remove(at: j)
                addSync(index: j, operationType: .delete, currentIndexCollection: &currentIndexCollection, syncResult: &syncResult, previousOperationType: &previousOperationType)
            }
            
        }
        
        while j < local.count {
            local.remove(at: j)
            addSync(index: j, operationType: .delete, currentIndexCollection: &currentIndexCollection, syncResult: &syncResult, previousOperationType: &previousOperationType)
        }
        
        if !currentIndexCollection.isEmpty {
            syncResult.append((operation: previousOperationType , indexCollection: currentIndexCollection))
        }
        
        return (local, syncResult)
    }
    
    private class func addSync(index: Int, operationType: ZSyncOperationType, currentIndexCollection: inout [Int], syncResult: inout [(operation: ZSyncOperationType, indexCollection: [Int])], previousOperationType: inout ZSyncOperationType) {
        
        if previousOperationType != operationType {
            
            if !currentIndexCollection.isEmpty {
                syncResult.append((operation: previousOperationType, indexCollection: currentIndexCollection))
            }
            previousOperationType = operationType
            currentIndexCollection = []
        }
        
        var updatedIndex = index
        if operationType == .delete {
            if let lastIndex = currentIndexCollection.last {
                updatedIndex = lastIndex + 1
            }
        }
        
        currentIndexCollection.append(updatedIndex)
    }
}
