// ArrayReplaceExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

public struct ArrayReplaceExpression<Content, T, U>: AggregateExpression, Sendable where
    Content: PSQLArrayRepresentable & TypeEquatable & Sendable,
    T: TypeEquatable & Sendable,
    U: TypeEquatable & Sendable,
    Content.CompareType == T.CompareType,
    T.CompareType == U.CompareType
{
    let content: Content
    let find: T
    let replace: U

    public init(_ content: Content, find: T, replace: U) {
        self.content = content
        self.find = find
        self.replace = replace
    }
}

extension ArrayReplaceExpression: SelectSQLExpression where
    Content: SelectSQLExpression,
    T: PSQLExpression,
    T: SelectSQLExpression,
    U: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: self.content, find: self.find, replace: self.replace)
    }

    struct _Select: SQLExpression {
        let content: Content
        let find: T
        let replace: U

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_REPLACE")
            serializer.write("(")
            self.content.selectSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.find.selectSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.replace.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
            serializer.writeCast(PostgresDataType.array(T.postgresDataType))
        }
    }
}

extension ArrayReplaceExpression: CompareSQLExpression where
    Content: CompareSQLExpression,
    T: CompareSQLExpression,
    U: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: self.content, find: self.find, replace: self.replace)
    }

    struct _Compare: SQLExpression {
        let content: Content
        let find: T
        let replace: U

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_REPLACE")
            serializer.write("(")
            self.content.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.find.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.replace.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayReplaceExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = [Content.CompareType]
}

extension ArrayReplaceExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayReplaceExpression<Content, T, U>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
