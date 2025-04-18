// MaxExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct MaxExpression<Content>: AggregateExpression, Sendable where Content: Sendable {
    let content: Content

    public init(_ content: Content) {
        self.content = content
    }
}

extension MaxExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: self.content)
    }

    struct _Select: SQLExpression {
        let content: Content

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("MAX")
            serializer.write("(")
            self.content.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension MaxExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: self.content)
    }

    struct _Compare: SQLExpression {
        let content: Content

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("MAX")
            serializer.write("(")
            self.content.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension MaxExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = Content.CompareType
}

extension MaxExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<MaxExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
