//
//  UpdateConsumerPresenter.swift
//  FetcherUI
//
//  Created by tarun-pt6229 on 14/03/23.
//

import Foundation
import FetcherBackEnd

class UpdateConsumerPresenter {
    
    weak var view: UpdateConsumerViewContract?
    var updateConsumer : UpdateConsumer
    weak var router: UpdateConsumerRouterContract?
    
    init(updateConsumer: UpdateConsumer) {
        self.updateConsumer = updateConsumer
    }
}

extension UpdateConsumerPresenter: UpdateConsumerPresenterContract {
    
    func viewLoaded(newValues: [String: Any], consumerId: Int) {
        let request = UpdateConsumerRequest(newValues: newValues, consumerId: consumerId)
        updateConsumer.execute(request: request, onSuccess: { [weak self] (response) in
            self?.result()
        }, onFailure: { [weak self] (error) in
            print("Failure")
            self?.failed(error: error)
        })
    }
}

extension UpdateConsumerPresenter {
    
    func result() {
        //For UI
        view?.load()
    }
    
    func failed(error: UpdateConsumerError) {
        //For UI
        print("Error: ", error)
    }
}

