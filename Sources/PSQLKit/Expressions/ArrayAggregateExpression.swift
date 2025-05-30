// ArrayAggregateExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct ArrayAggregateExpression<Content>: AggregateExpression, Sendable where Content: Sendable {
    let content: Content

    public init(_ content: Content) {
        self.content = content
    }
}

extension ArrayAggregateExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: self.content)
    }

    struct _Select: SQLExpression {
        let content: Content

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_AGG")
            serializer.write("(")
            self.content.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayAggregateExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: self.content)
    }

    struct _Compare: SQLExpression {
        let content: Content

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_AGG")
            serializer.write("(")
            self.content.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayAggregateExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = [Content.CompareType]
}

extension ArrayAggregateExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayAggregateExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
