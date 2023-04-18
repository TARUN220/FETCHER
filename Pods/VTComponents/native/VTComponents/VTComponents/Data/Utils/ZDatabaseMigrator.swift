//
//  ZDatabaseMigrator.swift
//  VTComponents-iOS
//
//  Created by Imthath M on 07/03/19.
//

import Foundation

public struct ZDBIndexDetail {
    public let name: String
    public let column: [(name: String, isAsc: Bool?)]
    
    public init(name: String, column: [(name: String, isAsc: Bool?)]) {
        self.name = name
        self.column = column
    }
}

public protocol ZDatabaseMigrationDataMaperProtocol {

    func getTableName() -> String

    func getTextColumns() -> [String]?
    func getIntegerColumns() -> [String]?
    func getBoolColumns() -> [String]?
    func getBlobColumns() -> [String]?

    func getPrimaryKeyColumns() -> [String]?
    func getUniqueColumns() -> [String]?
    
    func getIndexDetails() -> [ZDBIndexDetail]?
}

public extension ZDatabaseMigrationDataMaperProtocol {
    func getIndexDetails() -> [ZDBIndexDetail]? {
        return nil
    }
}
