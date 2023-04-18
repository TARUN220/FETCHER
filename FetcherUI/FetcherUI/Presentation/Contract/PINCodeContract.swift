//
//  PINCodeContract.swift
//  FetcherUI
//
//  Created by tarun-pt6229 on 07/03/23.
//

import Foundation

import Foundation
import FetcherBackEnd

public protocol AddPinCodeRouterContract: AnyObject {
    func selected()
}

public protocol AddPinCodePresenterContract: AnyObject {
    func viewLoaded(pinCode: PinCode)
}

public protocol AddPinCodeViewContract: AnyObject {
    func load()
    func failure()
}

public protocol PinCodeListRouterContract: AnyObject {
    func selected()
}

public protocol PinCodeListPresenterContract: AnyObject {
    func viewLoaded()
}

public protocol PinCodeListViewContract: AnyObject {
    func load(pinCodeList: [PinCode])
    func failure(error: GetPinCodeListError)
}

protocol SearchPinCodePresenterContract: AnyObject {
    func viewLoaded(columnName: String, columnValue: Any)
}

protocol SearchPinCodeRouterContract: AnyObject {
    
}

protocol SearchPinCodeViewContract: AnyObject {
    func load(pinCode: [PinCode], flag: inout Bool, id: inout Int)
    func failure(error: SearchPinCodeError)
}

protocol UpdatePinCodeRouterContract: AnyObject {
    func selected()
}

protocol UpdatePinCodePresenterContract: AnyObject {
    func viewLoaded(newValues: [String: Any], pinCodeId: Int)
}

protocol UpdatePinCodeViewContract: AnyObject {
    func load()
}
