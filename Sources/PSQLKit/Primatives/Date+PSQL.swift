import Foundation
import SQLKit
import PostgresKit

extension Date: PSQLExpression {
    public static var postgresColumnType: PostgresColumnType { .timestamp }
}

extension Date: SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("'\(self)'")
    }
}

extension Date: TypeEquatable {
    public typealias CompareType = Self
}

extension Date: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension Date: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

extension Date {
    public var psqlDate: PSQLDate { .init(self) }
    public var psqlTimestamp: PSQLTimestamp { .init(self) }
}

public protocol PSQLDateTime: Comparable, SQLExpression, PSQLExpression, Decodable, Encodable, TypeEquatable where CompareType == Date {
    var storage: Date { get }
    static var defaultFormatter: DateFormatter { get }
}

extension PSQLDateTime {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.storage < rhs.storage
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        Self.defaultFormatter.string(from: storage).serialize(to: &serializer)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(storage)
    }
}

public struct PSQLDate: PSQLDateTime {
    public let storage: Date
    
    public init(_ date: Date = .init()) {
        self.storage = date
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.storage = try container.decode(Date.self)
    }
    
    public static let defaultFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(abbreviation: "UTC")
        return f
    }()
}

extension PSQLDate: PSQLExpression {
    public static var postgresColumnType: PostgresColumnType { .date }
}

extension PSQLDate: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension PSQLDate: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

public struct PSQLTimestamp: PSQLDateTime {
    public let storage: Date
    
    public init(_ date: Date = .init()) {
        self.storage = date
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.storage = try container.decode(Date.self)
    }
    
    public static let defaultFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd hh:mm a"
        f.timeZone = TimeZone(abbreviation: "UTC")
        return f
    }()
}

extension PSQLTimestamp: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension PSQLTimestamp: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

extension PSQLTimestamp: PSQLExpression {
    public static var postgresColumnType: PostgresColumnType { .timestamp }
}
