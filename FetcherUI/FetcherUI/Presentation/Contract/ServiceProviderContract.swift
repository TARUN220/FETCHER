//
//  ServiceProviderContract.swift
//  FetcherUI
//
//  Created by tarun-pt6229 on 02/03/23.
//

import Foundation
import FetcherBackEnd

protocol AddServiceProviderRouterContract: AnyObject {
    func selected()
}

protocol AddServiceProviderPresenterContract: AnyObject {
    func viewLoaded(serviceProvider: ServiceProvider)
}

protocol AddServiceProviderViewContract: AnyObject {
    func load()
    func failure()
}

protocol ServiceProviderLoginRouterContract: AnyObject {
    
}

protocol ServiceProviderLoginViewContract: AnyObject {
    func loginSuccess()
    func invalidEmailId()
    func invalidPassword()
    func invalidRole()
    func dataBaseFailure()
}

protocol ServiceProviderLoginPresenterContract: AnyObject {
    func viewLoaded(columnName: String, columnValue: Any)
}

protocol SearchServiceProviderPresenterContract: AnyObject {
    func viewLoaded(columnName: String, columnValue: Any)
}

protocol SearchServiceProviderRouterContract: AnyObject {
    
}

protocol SearchServiceProviderViewContract: AnyObject {
    func load(serviceProvider: [ServiceProvider], flag: inout Bool)
    func failure(error: SearchServiceProviderError)
}

public protocol ServiceProviderListRouterContract: AnyObject {
    func selected()
}

public protocol ServiceProviderListPresenterContract: AnyObject {
    func viewLoaded()
}

public protocol ServiceProviderListViewContract: AnyObject {
    func load(serviceProviderList: [ServiceProvider])
    func failure(error: GetServiceProviderListError)
}

protocol DeleteServiceProviderRouterContract: AnyObject {
    func selected()
}

protocol DeleteServiceProviderPresenterContract: AnyObject {
    func viewLoaded(serviceProviderId: Int)
}

protocol DeleteServiceProviderViewContract: AnyObject {
    func load()
    func failure(error: DeleteServiceProviderError)
}

protocol UpdateServiceProviderPresenterContract: AnyObject {
    func viewLoaded(newValues: [String: Any], serviceProviderId: Int)
}

protocol UpdateServiceProviderViewContract: AnyObject {
    func load()
}

protocol UpdateServiceProviderRouterContract: AnyObject {
    func selected()
}
