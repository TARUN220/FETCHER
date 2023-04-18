//
//  UpdateAdminPresenter.swift
//  FetcherUI
//
//  Created by tarun-pt6229 on 14/03/23.
//

import Foundation
import FetcherBackEnd

class UpdateAdminPresenter {
    
    weak var view: UpdateAdminViewContract?
    var updateAdmin : UpdateAdmin
    weak var router: UpdateAdminRouterContract?
    
    init(updateAdmin: UpdateAdmin) {
        self.updateAdmin = updateAdmin
    }
}

extension UpdateAdminPresenter: UpdateAdminPresenterContract {
    
    func viewLoaded(newValues: [String: Any], adminId: Int) {
        let request = UpdateAdminRequest(newValues: newValues, adminId: adminId)
        updateAdmin.execute(request: request, onSuccess: { [weak self] (response) in
            self?.result()
        }, onFailure: { [weak self] (error) in
            print("Failure")
            self?.failed(error: error)
        })
    }
}

extension UpdateAdminPresenter {
    
    func result() {
        //For UI
        view?.load()
    }
    
    func failed(error: UpdateAdminError) {
        //For UI
        print("Error: ", error)
    }
}

