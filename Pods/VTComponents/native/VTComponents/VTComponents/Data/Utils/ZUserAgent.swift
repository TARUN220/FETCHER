//
//  ZUserAgent.swift
//  VTComponents
//
//  Created by agneesh-12638 on 09/09/22.
//

import Foundation
#if os(iOS) || os(iPadOS)
import WebKit
#endif


enum UserAgentParam {
    static let appName = "AppName"
    static let deviceName = "D"
    static let osVersion = "OSVersion"
    static let deviceTimeZone = "DTZ"
    static let theme = "T"
    static let font = "F"
    static let oAuthStatus = "OAuth"
    static let deviceLanguage = "L"
    static let buildVersion = "buildVersion"
    static let osName = "OSName"
    static let browserInfo = "bInfo"
}

public class ZAppUserAgent {
    
    public static let shared: ZAppUserAgent = ZAppUserAgent()
    
    private var params: SafeReadWrite<[String: String?]> = SafeReadWrite([String: String?]())
    
    public private(set) var _userAgent: String?
    
    init() {
        setDeviceName()
        setOSVersion()
        setTimeZoneInfo()
        setBuildVersion()
        setOAuthStatus()
        setOSName()
        setBrowserInfo()
    }
    
    // Note:- defaultMethods called in init

    private func setDeviceName() {
        var size = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        var machine = [Int8](repeating: 0,  count: size)
        sysctlbyname("hw.model", &machine, &size, nil, 0)
        let deviceName = String(cString: machine)
        params.write({ $0[UserAgentParam.deviceName] = deviceName })
    }
    
    private func setOSName() {
        #if os(macOS)
        params.write({ $0[UserAgentParam.osName] = "macOS" })
        #elseif os(iOS)
        params.write({ $0[UserAgentParam.osName] = "iOS" })
        #elseif os(watchOS)
        params.write({ $0[UserAgentParam.osName] = "watchOS" })
        #elseif os(tvOS)
        params.write({ $0[UserAgentParam.osName] = "tvOS" })
        #endif
    }
    
    private func setOSVersion() {
        let osVersion = " \(ProcessInfo.processInfo.operatingSystemVersion.majorVersion).\(ProcessInfo.processInfo.operatingSystemVersion.minorVersion).\(ProcessInfo.processInfo.operatingSystemVersion.patchVersion)"
        params.write({ $0[UserAgentParam.osVersion] = osVersion })
    }
    
    private func setTimeZoneInfo() {
        let timeZoneInfo = "GMT \(TimeZone.current.secondsFromGMT())(\(TimeZone.current.identifier))"
        params.write({ $0[UserAgentParam.deviceTimeZone] = timeZoneInfo })
    }
    
    private func setBuildVersion() {
        let buildVersion: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        params.write({ $0[UserAgentParam.buildVersion] = buildVersion })
    }
        
    private func setOAuthStatus() {
        params.write({ $0[UserAgentParam.oAuthStatus] = "1" })
    }
    
    private func setBrowserInfo() {
        #if os(macOS) || os(tvOS) || os(watchOS)
        params.write({ $0[UserAgentParam.browserInfo] = "" })
        #else
        runInMainThread {
            guard let browserString = WKWebView().value(forKey: "userAgent") as? String  else { return }
            var components = browserString.components(separatedBy: " ")
            components.removeFirst()
            let value = components.joined(separator: " ")
            params.write({ $0[UserAgentParam.browserInfo] = value })
        }
        #endif
    }
    
    //public methods
    
    public func getUserAgent(appName: String) -> String {
        setAppName(appName: appName)
        return getUserAgent()
    }
    
    public func setLanguage(_ language: String) {
        params.write({ $0[UserAgentParam.deviceLanguage] = language })
        constructUserAgent()
    }
    
    public func updateTheme(_ theme: String) {
        params.write({ $0[UserAgentParam.theme] = theme })
        constructUserAgent()
    }
    
    public func updateFont(_ font: String) {
        params.write({ $0[UserAgentParam.font] = font })
        constructUserAgent()
    }
    
    @discardableResult
    public func constructUserAgent() -> String {
        guard let appName = params.read({ $0[UserAgentParam.appName] as? String }), let buildVersion = params.read({ $0[UserAgentParam.buildVersion] as? String }), let browserInfo = params.read({ $0[UserAgentParam.browserInfo] as? String }) else {
            logger.assert(false, "unable to fetch device informations")
            return ""
        }
        
        var userAgent =  "\(appName)/\(buildVersion)\(browserInfo);"
        
        if let deviceName = params.read({ $0[UserAgentParam.deviceName] as? String }) {
            userAgent += "D:\(deviceName);"
        }
        
        if let osName = params.read({ $0[UserAgentParam.osName] as? String }) {
            userAgent += "OS:\(osName);"
        }
        
        if let osVersion = params.read({ $0[UserAgentParam.osVersion] as? String }) {
            userAgent += "OSVersion:\(osVersion);"
        }
        
        if let theme = params.read({ $0[UserAgentParam.theme] as? String }) {
            userAgent += "T:\(theme);"
        }
        
        if let font = params.read({ $0[UserAgentParam.font] as? String }) {
            userAgent += "F:\(font);"
        }
        
        if let deviceLanguage = params.read({ $0[UserAgentParam.deviceLanguage] as? String }) {
            userAgent += "L:\(deviceLanguage);"
        }
        
        if let deviceTimeZone = params.read({ $0[UserAgentParam.deviceTimeZone] as? String }) {
            userAgent += "DTZ:\(deviceTimeZone);"
        }
        
        if let oAuthStatus = params.read({ $0[UserAgentParam.oAuthStatus] as? String }) {
            userAgent += "OAuth:\(oAuthStatus);"
        }
        _userAgent = userAgent
        return userAgent
    }
    
    //helper methods
    
    private func setAppName(appName: String) {
        params.write({ $0[UserAgentParam.appName] = appName })
    }
    
    private func getUserAgent() -> String {
        guard let _userAgent = _userAgent else {
            return constructUserAgent()
        }
        
        return _userAgent
    }
}
