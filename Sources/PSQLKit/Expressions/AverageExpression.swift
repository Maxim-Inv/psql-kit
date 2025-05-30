// AverageExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct AverageExpression<Content>: AggregateExpression, Sendable where Content: Sendable {
    let content: Content

    public init(_ content: Content) {
        self.content = content
    }
}

extension AverageExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: self.content)
    }

    struct _Select: SQLExpression {
        let content: Content

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("AVG")
            serializer.write("(")
            self.content.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension AverageExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: self.content)
    }

    struct _Compare: SQLExpression {
        let content: Content

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("AVG")
            serializer.write("(")
            self.content.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension AverageExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = Content.CompareType
}

extension AverageExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<AverageExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
