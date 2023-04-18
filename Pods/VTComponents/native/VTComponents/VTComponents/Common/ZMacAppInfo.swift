//
//  ZMacAppInfo.swift
//  VTComponents
//
//  Created by Robin Rajasekaran on 24/09/22.
//

import Foundation


public enum ZMacAppInfo {
    
    case trident
    case cliq
    
    public var appDisplayName: String {
        switch self {
        case .trident:
            return "Trident"
            
        case .cliq:
            return "Zoho Cliq"
        }
    }
}


