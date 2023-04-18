//
//  DeleteConsumerPresenter.swift
//  FetcherUI
//
//  Created by tarun-pt6229 on 13/03/23.
//

import Foundation
import FetcherBackEnd

class DeleteConsumerPresenter {
    
    weak var view: DeleteConsumerViewContract?
    var deleteConsumer: DeleteConsumer
    weak var router: DeleteConsumerRouterContract?
    
    init(deleteConsumer: DeleteConsumer) {
        self.deleteConsumer = deleteConsumer
    }
}

extension DeleteConsumerPresenter: DeleteConsumerPresenterContract {
    
    func viewLoaded(consumerId: Int) {
        let request = DeleteConsumerRequest(consumerId: consumerId)
        deleteConsumer.execute(request: request, onSuccess: { [weak self] (response) in
            self?.result()
        }, onFailure: { [weak self] (error) in
            self?.failed(error: error)
        })
    }
}

extension DeleteConsumerPresenter {
    
    func result() {
        view?.load()
    }
    
    func failed(error: DeleteConsumerError) {
        view?.failure(error: error)
    }
}
