//
//  Error+Extension.swift
//  ZEditor-ZEditor
//
//  Created by siva-6975 on 09/09/22.
//

import Foundation

public extension Error {
    
    public func getDescription() -> String {
        if let errorObject = self as? NSError {
            return "errorCode: \(errorObject.code), domain: \(errorObject.domain), description: \(errorObject.localizedDescription)"
        } else {
            return "error: \(localizedDescription)"
        }
    }
}
