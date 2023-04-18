//
//  URLExtension.swift
//  VTComponents
//
//  Created by agneesh on 27/09/22.
//

import Foundation


extension URL {

    public var logDescription: String {
        get {
            self.absoluteString.getURLLogDescription()
        }
    }
}
