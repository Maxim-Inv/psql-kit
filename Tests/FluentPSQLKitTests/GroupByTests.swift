// GroupByTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
@testable import FluentPSQLKit

@Suite
struct GroupByTests {
    let f = FluentModel.as("x")

    @Test
    func testGroupModel() {
        var serializer = SQLSerializer.test
        GROUPBY {
            FluentModel.$name
        }
        .serialize(to: &serializer)

        let compare = #"GROUP BY "my_model"."name""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testGroupModelAlias() {
        var serializer = SQLSerializer.test
        GROUPBY {
            f.$name
        }
        .serialize(to: &serializer)

        let compare = #"GROUP BY "x"."name""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testGroupBoth() {
        var serializer = SQLSerializer.test
        GROUPBY {
            FluentModel.$name
            f.$name
        }
        .serialize(to: &serializer)

        let compare = #"GROUP BY "my_model"."name", "x"."name""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testGroupRaw() {
        var serializer = SQLSerializer.test
        GROUPBY {
            RawColumn<String>("cool")
        }
        .serialize(to: &serializer)

        let compare = #"GROUP BY "cool""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseTrue() {
        var serializer = SQLSerializer.test
        let bool = true
        GROUPBY {
            if bool {
                f.$name
            } else {
                f.$age
            }
        }
        .serialize(to: &serializer)

        let compare = #"GROUP BY "x"."name""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseFalse() {
        var serializer = SQLSerializer.test
        let bool = false
        GROUPBY {
            if bool {
                f.$name
            } else {
                f.$age
            }
        }
        .serialize(to: &serializer)

        let compare = #"GROUP BY "x"."age""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testSwitch() {
        var serializer = SQLSerializer.test
        enum Test {
            case one
            case two
            case three
        }

        let option = Test.two

        GROUPBY {
            switch option {
            case .one: f.$name
            case .two: f.$age
            case .three:
                f.$age
                f.$name
            }
        }
        .serialize(to: &serializer)

        let compare = #"GROUP BY "x"."age""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfTrue() {
        var serializer = SQLSerializer.test
        let bool = true
        GROUPBY {
            if bool {
                f.$name
            }
        }
        .serialize(to: &serializer)

        let compare = #"GROUP BY "x"."name""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfFalse() {
        var serializer = SQLSerializer.test
        let bool = false
        GROUPBY {
            if bool {
                f.$name
            }
        }
        .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testEmpty() {
        var serializer = SQLSerializer.test
        GROUPBY {}
            .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }
}
