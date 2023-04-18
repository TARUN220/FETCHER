//
//  ZJSONHelper.swift
//  ZohoMail
//
//  Created by Sivakarthick M on 08/03/17.
//  Copyright © 2017 Zoho Corporation. All rights reserved.
//

import Foundation

public struct ZJSONSerializer {

    public static func data(from dictionary: [String: Any]) -> Data? {

        var jsonData: Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        } catch {
            logger.log(error.localizedDescription, flag: Logger.Flag.error)
        }
        return jsonData
    }

    public static func data(from array: [Any]) -> Data? {

        let jsonData: Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
        } catch {
            logger.log(error.localizedDescription, flag: Logger.Flag.error)
            jsonData = nil
        }
        return jsonData
    }

    public static func data(from string: String) -> Data { // Added by Narayanan U

        var jsonData: Data!
        do {
            jsonData = try JSONSerialization.data(withJSONObject: string, options: .prettyPrinted)
        } catch {
            logger.log(error.localizedDescription, flag: Logger.Flag.error)
        }
        return jsonData
    }

    public static func string(from data: Data) -> String? {

        return String(data: data, encoding: .utf8)
    }

    public static func array(from data: Data) -> [Any]? {
        let jsonArray: [Any]?
        do {
            guard let responseArr = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [Any] else {
                logger.log("JSON Serializer Error!!!", flag: Logger.Flag.error)
                return nil
            }
            jsonArray = responseArr
        } catch {
            logger.log(error.localizedDescription, flag: Logger.Flag.error)
            jsonArray = nil
        }
        return jsonArray
    }

    public static func dictionary(from data: Data) -> [String: Any]? {

        var jsonDictionary: [String: Any]?
        do {
            jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any]
        } catch {
            logger.log(error.localizedDescription, flag: Logger.Flag.error)
        }
        return jsonDictionary
    }

    public static func string(from dictionary: [String: Any]) -> String? {

        guard let data = self.data(from: dictionary) else {return nil}
        let string = self.string(from: data)
        return string
    }

    public static func string(from array: [Any]) -> String? {

        guard let data = self.data(from: array) else {return nil}
        let string = self.string(from: data)
        return string
    }

    public static func array(from string: String) -> [Any]? { // Added by Narayanan U

        if let data = string.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
            } catch {
                logger.log(error.localizedDescription, flag: Logger.Flag.error)
            }
        }
        return nil
    }

    public static func dictionaryStringValue(from string: String) -> [String: String] {

        var jsonDictionary = [String: String]()
        do {
            let data = string.data(using: .utf8)
            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [String: String]
        } catch {
            logger.log(error.localizedDescription, flag: Logger.Flag.error)
        }
        return jsonDictionary
    }

    public static func dictionaryAnyValue(from text: String) -> [String: Any]? {

        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                logger.log(error.localizedDescription, flag: Logger.Flag.error)
            }
        }
        return nil
    }
}
