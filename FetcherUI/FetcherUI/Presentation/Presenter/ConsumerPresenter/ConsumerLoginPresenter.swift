//
//  ConsumerLoginPresenter.swift
//  FetcherUI
//
//  Created by tarun-pt6229 on 28/02/23.
//

import Foundation
import FetcherBackEnd

class ConsumerLoginPresenter {
    var view: ConsumerLoginViewContract?
    var searchConsumer: SearchConsumer
    weak var router: ConsumerLoginRouterContract?
    var isLogged: Bool?
    var emailId: String
    var password: String
    var consumer: Consumer?
    init(searchConsumer: SearchConsumer, emailId: String, password: String) {
        self.searchConsumer = searchConsumer
        self.emailId = emailId
        self.password = password
    }
}

extension ConsumerLoginPresenter: ConsumerLoginPresenterContract {
    
    func viewLoaded(columnName: String, columnValue: Any) {
        let request = SearchConsumerRequest(columnName: columnName, columnType: columnValue)
        searchConsumer.execute(request: request, onSuccess: { [weak self] (response) in
            self?.success(consumer: response.consumer)
        }, onFailure: { [weak self] (error) in
            self?.failure()
        })
        
        while self.consumer == nil && searchConsumer.searchConsumerError == nil {
            self.consumer = searchConsumer.searchConsumerResponse?.consumer[0]
        }
        
//        if searchConsumer.searchConsumerError != nil {
//            view?.invalidEmailId()
//            return
//        }
        
        if emailId != self.consumer?.emailId {
            view?.invalidEmailId()
            return
        }
        
        if password != self.consumer?.password {
            view?.invalidPassword()
            return
        }
        else if password == self.consumer?.password {
            isLogged = true
            view?.loginSuccess()
            return
        }
        
    }
}

extension ConsumerLoginPresenter {
    func success(consumer: [Consumer]) {
        isLogged = true
    }
    
    func failure() {
        isLogged = false
    }
}
