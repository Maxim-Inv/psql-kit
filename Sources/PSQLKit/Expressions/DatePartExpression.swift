import Foundation
import SQLKit
import PostgresKit

public struct DatePartExpression<Content>: AggregateExpression where
    Content: PSQLArrayRepresentable & TypeEquatable
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
    public var selectSqlExpression: SQLExpression {
        _Select(precision: precision, content: content)
    }
    
    private struct _Select: SQLExpression {
        let precision: String
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("DATE_PART")
            serializer.write("(")
            precision.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            content.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension DatePartExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<DatePartExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
