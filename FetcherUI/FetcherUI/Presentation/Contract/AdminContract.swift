//
//  AdminContract.swift
//  FetcherUI
//
//  Created by tarun-pt6229 on 01/03/23.
//

import Foundation

protocol AdminLoginRouterContract: AnyObject {
    
}

protocol AdminLoginViewContract: AnyObject {
    func loginSuccess()
    func invalidEmailId()
    func invalidPassword()
    func dataBaseFailure()
}

protocol AdminLoginPresenterContract: AnyObject {
    func viewLoaded(columnName: String, columnValue: Any)
}

protocol UpdateAdminPresenterContract: AnyObject {
    func viewLoaded(newValues: [String: Any], adminId: Int)
}

protocol UpdateAdminViewContract: AnyObject {
    func load()
}

protocol UpdateAdminRouterContract: AnyObject {
    func selected()
}
