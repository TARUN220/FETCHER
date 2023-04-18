//
//  ZErrorConstants.swift
//  VTComponents
//
//  Created by mani-7745 on 27/11/20.
//

import Foundation

public protocol ZGetErrorType {
    func isPermanentFailed() -> Bool
    func isNetworkLost() -> Bool
    func isTimeout() -> Bool
    func isAllowRetry() -> Bool
}

public enum ZAuthenticationError: Int, Codable {
    case sessionExpired = 0
    case invalidToken
    case tokenNotFound
    case unknownError
}

/// NetWorkErrorCode limit is 0 to 200
public enum ZNetWorkErrorCode {
    case unknownError
    case networkConnectionLost
    case parsingFailed
    case requestTimeoutError
    case serverFailure
    case sslError
    case authError(code: ZAuthenticationError)
}

extension ZNetWorkErrorCode: RawRepresentable, Codable {
    
    public typealias RawValue = Int
    
    public init?(rawValue: RawValue) {
        
        switch rawValue {
            case 0...50:
                if let authErrorCode = ZAuthenticationError(rawValue:  rawValue) {
                    self = .authError(code: authErrorCode)
                } else {
                    return nil
            }
            case 51: self = .unknownError
            case 52: self = .networkConnectionLost
            case 53: self = .parsingFailed
            case 54: self = .requestTimeoutError
            case 55: self = .serverFailure
            case 56: self = .sslError
            default:
                return nil
        }
    }
    
    public var rawValue: RawValue {
        switch self {
            case .unknownError:
            return 51
            case .networkConnectionLost:
            return 52
            case .parsingFailed:
            return 53
            case .requestTimeoutError:
            return 54
            case .serverFailure:
            return 55
            case .sslError:
            return 56
            case .authError(let code):
                return code.rawValue
        }
    }
}

extension ZNetWorkErrorCode: ZGetErrorType {
    
    
    public func isPermanentFailed() -> Bool {
        self == .serverFailure || self == .unknownError || self == .parsingFailed || self == .authError(code: .unknownError)
    }
    
    public func isNetworkLost() -> Bool {
        self == .networkConnectionLost
    }
    
    public func isTimeout() -> Bool {
        self == .requestTimeoutError
    }
    
    public func isAllowRetry() -> Bool {
        self == .networkConnectionLost || self == .requestTimeoutError
    }
}

open class ZNetworkErrorInfo: Error, Codable, Equatable {
    public var code: ZNetWorkErrorCode
    public var message: String?
    
    public init(code: ZNetWorkErrorCode) {
        self.code = code
    }
    
    public init(code: ZNetWorkErrorCode, message: String) {
        self.code = code
        self.message = message
    }
    
    public static func == (lhs: ZNetworkErrorInfo, rhs: ZNetworkErrorInfo) -> Bool {
        return lhs.code == rhs.code
    }
}

public extension Error {
    func getNetworkErrorType() -> ZErrorType {
        let error = self as NSError
        switch error.code {
            case NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet:
                return .networkUnavailable
            case NSURLErrorTimedOut:
                return .timeout
            case 400:
                return .invalidRequestError                
            default:
                return .unknownError
        }
    }
}
