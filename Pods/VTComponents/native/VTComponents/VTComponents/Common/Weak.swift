//
//  Weak.swift
//  VTComponents
//
//  Created by Robin Rajasekaran on 11/11/20.
//

import Foundation


open class Weak<T: AnyObject> {
    
    open weak var value : T?
    
    public init(value: T) {
        self.value = value
    }
}


