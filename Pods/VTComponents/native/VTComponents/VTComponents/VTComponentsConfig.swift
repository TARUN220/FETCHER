//
//  VTComponentsConfig.swift
//  VTComponents
//
//  Created by Rahul T on 06/10/21.
//

import Foundation

public class VTComponentsConfig {
    
    public static let shared = VTComponentsConfig()
    
    public var logger = Logger()
}

var logger: Logger {
    return VTComponentsConfig.shared.logger
}
