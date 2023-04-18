//
//  PinCodeListPresenter.swift
//  FetcherUI
//
//  Created by tarun-pt6229 on 07/03/23.
//

import Foundation
import FetcherBackEnd

class PinCodeListPresenter {
    weak var view: PinCodeListViewContract?
    weak var router: PinCodeListRouterContract?
    var pinCodeList: GetPinCodeList
    
    init(pinCodeList: GetPinCodeList) {
        self.pinCodeList = pinCodeList
    }
}

extension PinCodeListPresenter: PinCodeListPresenterContract {
    func viewLoaded() {
        let request = GetPinCodeListRequest()
        pinCodeList.execute(request: request, onSuccess: { [weak self] (response) in
            self?.result(pinCodeList: response.pinCode)
        }, onFailure: { [weak self] (error) in
            self?.failed(error: error)
        })
        
        while pinCodeList.response == nil && pinCodeList.error == nil {
            
        }
        if let response = pinCodeList.response {
            view?.load(pinCodeList: response.pinCode)
        }
        else if let error = pinCodeList.error {
            view?.failure(error: error)
        }
    }
}

extension PinCodeListPresenter {
    func result(pinCodeList: [PinCode]) {
        view?.load(pinCodeList: pinCodeList)
    }
    
    func failed(error: GetPinCodeListError) {
        view?.failure(error: error)
    }
}
