//
//  ZAppInfoUtil.swift
//  Common
//
//  Created by Rahul T on 30/07/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import Foundation

public struct ZAppInfoUtil {
    
    private static var _buildVersion: String?
    public static func getBuildVersion() -> String {
        if _buildVersion != nil {
            return _buildVersion!
        }
        _buildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        return _buildVersion!
    }
    
    private static var _buildNo: Int?
    public static func getBuildNo() -> Int {
        if _buildNo != nil {
            return _buildNo!
        }
        _buildNo = Int(Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String)!
        return _buildNo!
    }
    
    private static var _bundleName: String?
    public static func getBundleName() -> String {
        if _bundleName != nil {
            return _bundleName!
        }
        _bundleName = Bundle.main.bundleIdentifier!
        return _bundleName!
    }
}
