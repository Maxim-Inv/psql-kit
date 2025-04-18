// Float+PSQL.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

extension Float: PSQLExpression {
    public static var postgresDataType: PostgresDataType { .numeric }
}

extension Float: @retroactive SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Float: TypeEquatable {
    public typealias CompareType = Self
}

extension Float: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression { self }
}

extension Float: Concatenatable {}
extension Float: Coalescable {}

extension Float: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension Float: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

extension Float: MutationSQLExpression {
    public var mutationSqlExpression: some SQLExpression { self }
}
