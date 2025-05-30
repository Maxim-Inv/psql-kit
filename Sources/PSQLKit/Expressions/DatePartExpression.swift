// DatePartExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct DatePartExpression<Content>: AggregateExpression, Sendable where
    Content: PSQLArrayRepresentable & TypeEquatable & Sendable
{
    let precision: String
    let content: Content

    public init(_ precision: String, _ content: Content) {
        self.precision = precision
        self.content = content
    }
}

extension DatePartExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(precision: self.precision, content: self.content)
    }

    struct _Select: SQLExpression {
        let precision: String
        let content: Content

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("DATE_PART")
            serializer.write("(")
            self.precision.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.content.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension DatePartExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<DatePartExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
