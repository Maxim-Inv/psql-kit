// Double+PSQL.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

extension Double: PSQLExpression {
    public static var postgresDataType: PostgresDataType { .numeric }
}

extension Double: @retroactive SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Double: TypeEquatable {
    public typealias CompareType = Self
}

extension Double: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression { self }
}

extension Double: Concatenatable {}
extension Double: Coalescable {}

extension Double: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension Double: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

extension Double: MutationSQLExpression {
    public var mutationSqlExpression: some SQLExpression { self }
}
