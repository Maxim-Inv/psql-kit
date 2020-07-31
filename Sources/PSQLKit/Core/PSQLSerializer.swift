import Foundation

struct PSQLSerializer {
    var psql: String
    var binds: [Encodable]
    
    init() {
        self.psql = ""
        self.binds = []
    }
    
    mutating func write(bind encodable: Encodable) {
        self.binds.append(encodable)
        self.bindPlaceholder(at: self.binds.count)
            .serialize(to: &self)
    }
    
    mutating func write(_ psql: String) {
        self.psql += psql
    }

    func bindPlaceholder(at position: Int) -> PSQLExpression {
        return PSQLRaw("$" + position.description)
    }

    func literalBoolean(_ value: Bool) -> PSQLExpression {
        switch value {
        case false:
            return PSQLRaw("false")
        case true:
            return PSQLRaw("true")
        }
    }
    
    mutating func writeSpace() {
        self.write(" ")
    }
    
    mutating func writeQuote() {
        self.write("\"")
    }
    
    mutating func writePeriod() {
        self.write(".")
    }
}
