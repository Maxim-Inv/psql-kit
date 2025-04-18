// Int+PSQL.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

extension Int: PSQLExpression {
    public static var postgresDataType: PostgresDataType { .int4 }
}

extension Int: @retroactive SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Int: TypeEquatable {
    public typealias CompareType = Self
}

extension Int: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression { self }
}

extension Int: Concatenatable {}
extension Int: Coalescable {}

extension Int: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension Int: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

extension Int: MutationSQLExpression {
    public var mutationSqlExpression: some SQLExpression { self }
}

extension Int: OrderBySQLExpression {
    public var orderBySqlExpression: some SQLExpression { self }
}
