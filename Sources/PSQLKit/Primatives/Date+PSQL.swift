// Date+PSQL.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import PostgresNIO
import SQLKit

extension Date: PSQLExpression {
    public static var postgresDataType: PostgresDataType { .timestamp }
}

extension Date: @retroactive SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("'\(self)'")
    }
}

extension Date: TypeEquatable {
    public typealias CompareType = Self
}

extension Date: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression { self }
}

extension Date: Concatenatable {}
extension Date: Coalescable {}

extension Date: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension Date: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

extension Date: MutationSQLExpression {
    public var mutationSqlExpression: some SQLExpression { self }
}

extension Date {
    public var psqlDate: PSQLDate { .init(self) }
    public var psqlTimestamp: PSQLTimestamp { .init(self) }
}

public protocol PSQLDateTime: Comparable, SQLExpression, PSQLExpression, Decodable, Encodable, TypeEquatable where CompareType == Date {
    var storage: Date { get }
    init(_ date: Date)
    static var defaultFormatter: DateFormatter { get }
}

extension PSQLDateTime {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.storage < rhs.storage
    }

    public func serialize(to serializer: inout SQLSerializer) {
        Self.defaultFormatter.string(from: storage).serialize(to: &serializer)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(storage)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decoded = try container.decode(Date.self)
        let string = Self.defaultFormatter.string(from: decoded)
        let date = Self.defaultFormatter.date(from: string)! // should not fail as it was encoded using same
        self.init(date)
    }
}

public struct PSQLDate: PSQLDateTime {
    public let storage: Date

    public init(_ date: Date = .init()) {
        self.storage = date
    }

    public static let defaultFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(abbreviation: "UTC")
        return f
    }()
}

extension PSQLDate: PSQLExpression {
    public static var postgresDataType: PostgresDataType { .date }
}

extension PSQLDate: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression { self }
}

extension PSQLDate: Concatenatable {}
extension PSQLDate: Coalescable {}

extension PSQLDate: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension PSQLDate: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

extension PSQLDate: MutationSQLExpression {
    public var mutationSqlExpression: some SQLExpression { self }
}

public struct PSQLTimestamp: PSQLDateTime {
    public let storage: Date

    public init(_ date: Date = .init()) {
        self.storage = date
    }

    public static let defaultFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd hh:mm a"
        f.timeZone = TimeZone(abbreviation: "UTC")
        return f
    }()
}

extension PSQLTimestamp: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression { self }
}

extension PSQLTimestamp: Concatenatable {}
extension PSQLTimestamp: Coalescable {}

extension PSQLTimestamp: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension PSQLTimestamp: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

extension PSQLTimestamp: MutationSQLExpression {
    public var mutationSqlExpression: some SQLExpression { self }
}

extension PSQLTimestamp: PSQLExpression {
    public static var postgresDataType: PostgresDataType { .timestamp }
}
