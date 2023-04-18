//
//  AdminLoginPresenter.swift
//  FetcherUI
//
//  Created by tarun-pt6229 on 01/03/23.
//

import Foundation
import FetcherBackEnd

class AdminLoginPresenter {
    var view: AdminLoginViewContract?
    weak var router: AdminLoginRouterContract?
    var searchAdmin: SearchAdmin
    var isLogged: Bool? = false
    var emailId: String
    var password: String
    var admin: Admin?
    init(searchAdmin: SearchAdmin, emailId: String, password: String) {
        self.searchAdmin = searchAdmin
        self.emailId = emailId
        self.password = password
    }
}

extension AdminLoginPresenter: AdminLoginPresenterContract {
    func viewLoaded(columnName: String, columnValue: Any) {
        let request = SearchAdminRequest(columnName: columnName, columnValue: columnValue)
        searchAdmin.execute(request: request, onSuccess: { [weak self] (response) in
            self?.success(admin: response.admin)
        }, onFailure: { [weak self] (error) in
            self?.failure()
        })
        
        while self.admin == nil && searchAdmin.searchAdminError == nil {
            self.admin = searchAdmin.searchAdminResponse?.admin[0]
        }
        
//        if searchAdmin.searchAdminError != nil {
//            view?.invalidEmailId()
//            return
//        }
        
        if emailId != self.admin?.emailId {
            view?.invalidEmailId()
            return
        }
        
        if password != self.admin?.password {
            view?.invalidPassword()
            return
        }
        else if password == self.admin?.password {
            isLogged = true
            view?.loginSuccess()
            return
        }

    }
    
    
}

extension AdminLoginPresenter {
    func success(admin: [Admin]) {
        isLogged = true
    }
    
    func failure() {
        isLogged = false
    }
}
