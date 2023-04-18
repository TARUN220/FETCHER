//
//  UpdatePinCodePresenter.swift
//  FetcherUI
//
//  Created by tarun-pt6229 on 13/03/23.
//

import Foundation
import FetcherBackEnd

class UpdatePinCodePresenter {
    
    weak var view: UpdatePinCodeViewContract?
    var updatePinCode: UpdatePinCode
    weak var router: UpdatePinCodeRouterContract?
    
    init(updatePinCode: UpdatePinCode) {
        self.updatePinCode = updatePinCode
    }
}

extension UpdatePinCodePresenter: UpdatePinCodePresenterContract {
    
    func viewLoaded(newValues: [String: Any], pinCodeId: Int) {
        let request = UpdatePinCodeRequest(newValues: newValues, pinCodeId: pinCodeId)
        updatePinCode.execute(request: request, onSuccess: { [weak self] (response) in
            self?.result()
        }, onFailure: { [weak self] (error) in
            self?.failed(error: error)
        })
        
        while updatePinCode.response == nil && updatePinCode.error == nil {
            
        }
        if let response = updatePinCode.response {
            view?.load()
        }
        else if let error = updatePinCode.error {
//            view?.failure()
            print("Error")
        }
    }
}

extension UpdatePinCodePresenter {
    
    func result() {
        view?.load()
    }
    
    func failed(error: UpdatePinCodeError) {
        
    }
}

