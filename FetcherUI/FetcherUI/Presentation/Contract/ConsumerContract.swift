//
//  ConsumerContract.swift
//  FetcherUI
//
//  Created by tarun-pt6229 on 22/02/23.
//

import Foundation
import FetcherBackEnd

protocol AddConsumerRouterContract: AnyObject {
    func selected()
}

protocol AddConsumerPresenterContract: AnyObject {
    func viewLoaded(consumer: Consumer)
}

protocol AddConsumerViewContract: AnyObject {
    func load()
    func failure()
}

protocol SearchConsumerPresenterContract: AnyObject {
    func viewLoaded(columnName: String, columnValue: Any)
}

protocol SearchConsumerRouterContract: AnyObject {
    
}

protocol SearchConsumerViewContract: AnyObject {
    func load(consumer: [Consumer], flag: inout Bool)
    func failure(error: SearchConsumerError)
}

protocol ConsumerLoginRouterContract: AnyObject {
    
}

protocol ConsumerLoginViewContract: AnyObject {
    func loginSuccess()
    func invalidEmailId()
    func invalidPassword()
    func dataBaseFailure()
}

protocol ConsumerLoginPresenterContract: AnyObject {
    func viewLoaded(columnName: String, columnValue: Any)
}

public protocol ConsumerListRouterContract: AnyObject {
    func selected()
}

public protocol ConsumerListPresenterContract: AnyObject {
    func viewLoaded()
}

public protocol ConsumerListViewContract: AnyObject {
    func load(consumerList: [Consumer])
    func failure(error: GetConsumerListError)
}

protocol DeleteConsumerRouterContract: AnyObject {
    func selected()
}

protocol DeleteConsumerPresenterContract: AnyObject {
    func viewLoaded(consumerId: Int)
}

protocol DeleteConsumerViewContract: AnyObject {
    func load()
    func failure(error: DeleteConsumerError)
}

protocol UpdateConsumerPresenterContract: AnyObject {
    func viewLoaded(newValues: [String: Any], consumerId: Int)
}

protocol UpdateConsumerViewContract: AnyObject {
    func load()
}

protocol UpdateConsumerRouterContract: AnyObject {
    func selected()
}
