//
//  StringExtension.swift
//  ZohoMail
//
//  Created by Robin Rajasekaran on 19/12/18.
//  Copyright © 2018 Zoho Corporation. All rights reserved.
//

import Foundation


extension String {
    
    public var length: Int {
        return (self as NSString).length
    }
    
    public func toBool() -> Bool? {
        switch self.lowercased() {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            if let value = Int(self), value > 0 //Added this to fix if the string contains integer values > 1 to return true
            {
                return true
            }
            return nil
        }
    }
    
    public func replacingWhiteSpaceCharacters() -> String {
        var str = self
        for index in 0...str.length-1 {
            if str.isWhitespaceCharacter(in: NSRange(location: index, length: 1)) {
                str = (str as NSString).replacingCharacters(in: NSRange(location: index, length: 1), with: " ")
            }
        }
        return str
    }
    
    public func isWhitespaceCharacter(in range: NSRange) -> Bool {
        if let character = (self as NSString).substring(with: range).utf16.first, CharacterSet.whitespacesAndNewlines.contains(UnicodeScalar(character)!) {
            return true
        }
        return false
    }
    
    public func getPlaceHolderLetters(limit: Int = 2, upperCased: Bool = true) -> String {
        if self.isEmpty {
            return ""
        }
        var result = ""
        let splitedArr = self.split(separator: " ")
        for wordSequence in splitedArr {
            let word = String(wordSequence)
            if let firstLetter = getFirstAlphabet(from: word) {
                result += firstLetter
            }
            if result.count == limit {
                break
            }
        }
        if result.isEmpty, let char = self.first {
            result = String(char)
        }
        result = upperCased ? result.uppercased() : result
        return result
    }
    
    public func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    public mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    public func trimTrailingWhitespaces() -> String {
        var trimmedString = self
        while trimmedString.last?.isWhitespace == true {
            trimmedString = String(trimmedString.dropLast())
        }
        return trimmedString
    }
    
    public func insensitiveContains(_ string: String) -> Bool {
        return self.range(of: string, options: [.diacriticInsensitive, .caseInsensitive, .widthInsensitive]) != nil
    }
    
    
    // MARK: - Helper methods
    
    private func getFirstAlphabet(from string: String) -> String? {
        for uniCode in string.unicodeScalars {
            if CharacterSet.letters.contains(uniCode) {
                return String(uniCode)
            }
        }
        return nil
    }
}

//URL Encoding

extension String {
    
    public func encodeValue(with additionalCharacterSet: CharacterSet? = nil) -> String {
        //Altered characterSet to encode additional invalid characters (Narayanan U)
        
        var charSet: CharacterSet = CharacterSet(charactersIn: "=+&:,'\"#%/<>?@\\^`{|} ").inverted//CharacterSet.urlQueryAllowed // or use inverted set of "=+&:,'\"#%/<>?@\\^`{|}"
        if additionalCharacterSet != nil {
            charSet = charSet.intersection(additionalCharacterSet!)
        }
        let result: String = self.addingPercentEncoding(withAllowedCharacters: charSet)!
        return result
    }
    
    public func encodeURL() -> String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    public func encodeURLIfNotValid() -> URL? {
        if let url = URL(string: self) {
            return url
        }
        else if let encodedURLStr = encodeURL() {
            return URL(string: encodedURLStr)
        }
        return nil
    }
}

extension String {
    
    public mutating func replacingOccurrencesWithLiteralSearch(of string: String, with target: String) {
        self = replacingOccurrences(of: string, with: target, options: .literal, range: Range(NSMakeRange(0, length), in: self))
    }
    
    public func getURLLogDescription() -> String {
        return self.replacingOccurrences(of: NSUserName(), with: "***")
    }
}

