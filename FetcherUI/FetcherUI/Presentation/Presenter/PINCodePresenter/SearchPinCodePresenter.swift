//
//  SearchPinCodePresenter.swift
//  FetcherUI
//
//  Created by tarun-pt6229 on 07/03/23.
//

import Foundation
import FetcherBackEnd

class SearchPinCodePresenter {
    weak var view: SearchPinCodeViewContract?
    var searchPinCode: SearchPinCode
    weak var router: SearchPinCodeRouterContract?
    var pinCode: PinCode?
    var flag = false
    var id = 0
    init(searchPinCode: SearchPinCode) {
        self.searchPinCode = searchPinCode
    }
}

extension SearchPinCodePresenter: SearchPinCodePresenterContract {
    func viewLoaded(columnName: String, columnValue: Any) {
        let request = SearchPinCodeRequest(columnName: columnName, columnType: columnValue)
        searchPinCode.execute(request: request, onSuccess: { [weak self] (response) in
            self?.result(pinCode: response.pinCode)
        }, onFailure: { [weak self] (error) in
            self?.failure(error: error)
        })
        while searchPinCode.searchPinCodeResponse == nil && searchPinCode.searchPinCodeError == nil {
            sleep(1)
        }
        if let error = searchPinCode.searchPinCodeError {
            view?.failure(error: error)
        }
        if let pinCode = searchPinCode.searchPinCodeResponse?.pinCode {
            view?.load(pinCode: pinCode, flag: &flag, id: &id)
        }
    }
    }

extension SearchPinCodePresenter {
    func result(pinCode: [PinCode]) {
        view?.load(pinCode: pinCode, flag: &flag, id: &id)
    }
    
    func failure(error: SearchPinCodeError) {
        view?.failure(error: error)
    }
}
