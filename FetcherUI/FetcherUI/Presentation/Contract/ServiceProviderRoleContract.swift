//
//  ServiceProviderRoleContract.swift
//  FetcherUI
//
//  Created by tarun-pt6229 on 02/03/23.
//

import Foundation
import FetcherBackEnd

public protocol AddServiceProviderRoleRouterContract: AnyObject {
    func selected()
}

public protocol AddServiceProviderRolePresenterContract: AnyObject {
    func viewLoaded(serviceProviderRole: ServiceProviderRole)
}

public protocol AddServiceProviderRoleViewContract: AnyObject {
    func load()
    func failure()
}

public protocol ServiceProviderRoleListRouterContract: AnyObject {
    func selected()
}

public protocol ServiceProviderRoleListPresenterContract: AnyObject {
    func viewLoaded()
}

public protocol ServiceProviderRoleListViewContract: AnyObject {
    func load(serviceProviderRoleList: [ServiceProviderRole])
    func failure(error: GetServiceProviderRoleListError)
}

protocol SearchServiceProviderRolePresenterContract: AnyObject {
    func viewLoaded(columnName: String, columnValue: Any)
}

protocol SearchServiceProviderRoleRouterContract: AnyObject {
    
}

protocol SearchServiceProviderRoleViewContract: AnyObject {
    func load(serviceProviderRole: [ServiceProviderRole], flag: inout Bool, id: inout Int)
    func failure(error: SearchServiceProviderRoleError)
}

protocol UpdateServiceProviderRoleRouterContract: AnyObject {
    func selected()
}

protocol UpdateServiceProviderRolePresenterContract: AnyObject {
    func viewLoaded(newValues: [String: Any], serviceProviderRoleId: Int)
}

protocol UpdateServiceProviderRoleViewContract: AnyObject {
    func load()
}
