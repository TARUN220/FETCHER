//
//  ServiceContract.swift
//  FetcherUI
//
//  Created by tarun-pt6229 on 08/03/23.
//

import Foundation
import FetcherBackEnd

protocol NewServiceRouterContract: AnyObject {
    func selected()
}

protocol NewServicePresenterContract: AnyObject {
    func viewLoaded(service: Service)
}

protocol NewServiceViewContract: AnyObject {
//    func serviceSuccess(service: Service)
    func serviceRequested()
    func serviceBooked()
    func serviceSuccess()
    func serviceRejected()
}

public protocol ServiceRequestListRouterContract: AnyObject {
    func selected()
}

public protocol ServiceRequestListPresenterContract: AnyObject {
    func viewLoaded(columnName: String, columnValue: Any)
}

public protocol ServiceRequestListViewContract: AnyObject {
    func load(serviceRequestList: [Service])
    func failure(error: GetServiceRequestListError)
}

protocol SearchServicePresenterContract: AnyObject {
    func viewLoaded(columnName: String, columnValue: Any)
}

protocol SearchServiceRouterContract: AnyObject {
    
}

protocol SearchServiceViewContract: AnyObject {
    func load(service: [Service], flag: inout Bool, id: inout Int)
    func failure(error: SearchServiceError)
}

protocol UpdateServiceRouterContract: AnyObject {
    func selected()
}

protocol UpdateServicePresenterContract: AnyObject {
    func viewLoaded(newValues: [String: Any], serviceId: Int)
}

protocol UpdateServiceViewContract: AnyObject {
    func load()
}

protocol DeleteServiceRouterContract: AnyObject {
    func selected()
}

protocol DeleteServicePresenterContract: AnyObject {
    func viewLoaded(columnName: String, columnValue: Any)
}

protocol DeleteServiceViewContract: AnyObject {
    func load()
    func failure(error: DeleteServiceError)
}
