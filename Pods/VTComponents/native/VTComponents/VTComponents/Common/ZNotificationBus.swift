//
//  ZNotificationBus.swift
//  ZohoMail
//
//  Created by Sivakarthick M on 07/02/17.
//  Copyright © 2017 Zoho Corporation. All rights reserved.
//

import Foundation

public protocol ZNotificationNotifiable {

    func notify<T>(onMainThread: Bool, _ notificationType: T.Type, callback: @escaping (T) -> Void)
}

public protocol ZNotificationObservable {

    func add<T>(observer: T, for notificationType: T.Type)
    func remove<T>(observer: T, for notificationType: T.Type)
}

public struct ZObserver: Hashable {

    public weak var observer: AnyObject?
    public var identifier: ObjectIdentifier

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    public init(observer: AnyObject) {

        self.observer = observer
        self.identifier = ObjectIdentifier(observer)
    }

    public static func == (lhs: ZObserver, rhs: ZObserver) -> Bool {

        return lhs.observer === rhs.observer
    }
}

public class ZNotificationCenter: ZNotificationNotifiable, ZNotificationObservable {

    @available(OSX 10.10, *)
    public static let shared: ZNotificationCenter = ZNotificationCenter()

    public var observers: [ObjectIdentifier: [ObjectIdentifier: ZObserver]] = [ObjectIdentifier: [ObjectIdentifier: ZObserver]]()
    private let serialQueue: DispatchQueue = DispatchQueue(label: "zoho.vtouch.mail")
    private let postNotificationQueue: DispatchQueue

    @available(OSX 10.10, *)
    public init(queue: DispatchQueue = DispatchQueue.global(qos: .background)) {
        self.postNotificationQueue = queue
    }

    //TODO:- observer may get deallocated before adding since called async
    public func add<T>(observer: T, for notificationType: T.Type) {
        self.serialQueue.async {
            let identifier = ObjectIdentifier(notificationType)
            var observers = self.observers[identifier] ?? [ObjectIdentifier: ZObserver]()
            let zObserver = ZObserver(observer: observer as AnyObject)
            observers.updateValue(zObserver, forKey: zObserver.identifier)
            self.observers[identifier] = observers
        }
    }

    public func notify<T>(onMainThread: Bool = false, _ notificationType: T.Type, callback: @escaping (T) -> Void) {
        self.serialQueue.async {
            let identifier = ObjectIdentifier(notificationType)
            guard let observers = self.observers[identifier] else {
                return
            }
            for (_, observer) in observers {
                let queue = onMainThread ? DispatchQueue.main : self.postNotificationQueue
                queue.async {
                    if observer.observer != nil {
                        callback((observer.observer as! T))
                    }
                }
            }
        }
    }

    public func remove<T>(observer: T, for notificationType: T.Type) {
//        self.serialQueue.sync {
//            let identifier = ObjectIdentifier(notificationType)
//            self.observers[identifier]?.removeValue(forKey: ObjectIdentifier(observer as AnyObject))
//        }
        //Commenting the above lines as this causes a crash - "dispatch_sync called on queue already owned by current thread"
    }
}
