//
//  AddPinCodePresenter.swift
//  FetcherUI
//
//  Created by tarun-pt6229 on 13/03/23.
//

import Foundation
import FetcherBackEnd

class AddPinCodePresenter {
    weak var view: AddPinCodeViewContract?
    weak var router: AddPinCodeRouterContract?
    var addPinCode: AddPinCode
    
    init(addPinCode: AddPinCode) {
        self.addPinCode = addPinCode
    }
}

extension AddPinCodePresenter: AddPinCodePresenterContract {
    func viewLoaded(pinCode: FetcherBackEnd.PinCode) {
        let request = AddPinCodeRequest(pinCode: pinCode)
        addPinCode.execute(request: request, onSuccess: { [weak self] (response) in
            self?.result()
        }, onFailure: { [weak self] (error) in
            self?.failed()
        })
        
        while addPinCode.response == nil {
            
        }
    //        //sleep(5)
    //
        if addPinCode.response != nil {
            print("%%")
            view?.load()
        }
        else {
            view?.failure()
        }
    }
}

extension AddPinCodePresenter {
    func result() {
        view?.load()
    }
    
    func failed() {
        view?.failure()
    }
}
