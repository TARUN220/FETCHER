//
//  DataExtension.swift
//  VTComponents
//
//  Created by Robin Rajasekaran on 02/09/21.
//

import Foundation


extension Data {

    public var json: Any? {
        return try? JSONSerialization.jsonObject(with: self, options: [])
    }
}


