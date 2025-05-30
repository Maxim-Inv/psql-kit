// FluentTests.swift
// Copyright (c) 2024 hiimtmac inc.

import FluentKit
import Foundation
import SQLKit
import Testing
@testable import FluentPSQLKit

@Suite
struct FluentTests {
    @FluentCTE("pet")
    final class Pet: Model, @unchecked Sendable {
        @ID
        var id: UUID?
        @Field(key: "name")
        var name: String
        @Parent(key: "owner_id")
        var owner: Owner
        @Timestamp(key: "created_at", on: .create)
        var createdAt: Date?

        init() {}
    }

    @FluentCTE("thing")
    final class Thing: Model, @unchecked Sendable {
        @ID
        var id: UUID?
        @Field(key: "name")
        var name: String
        @OptionalParent(key: "parent_id")
        var parent: Owner?

        init() {}
    }

    @FluentCTE("owner")
    final class Owner: Model, @unchecked Sendable {
        @ID
        var id: UUID?
        @Field(key: "name")
        var name: String
        @Field(key: "age")
        var age: Int
        @Field(key: "bday")
        var bday: PSQLDate

        init() {}
    }

    @Test
    func testRelationships() {
        var serializer = SQLSerializer.test
        let p = Pet.as("p")
        let o = Owner.as("o")
        let t = Thing.as("t")

        let b = QUERY {
            SELECT {
                p.$owner
                Pet.$owner
            }
            WHERE {
                p.$owner == o.$id
                t.$parent == o.$id
                Pet.$owner == Owner.$id
                Thing.$parent == Owner.$id
                p.$owner == Owner.$id
                t.$parent == Owner.$id
            }
            GROUPBY {
                p.$owner
                Pet.$owner
                Thing.$parent
                t.$parent
            }
        }

        b.serialize(to: &serializer)
        #expect(serializer.sql == #"SELECT "p"."owner_id"::UUID, "pet"."owner_id"::UUID WHERE ("p"."owner_id" = "o"."id") AND ("t"."parent_id" = "o"."id") AND ("pet"."owner_id" = "owner"."id") AND ("thing"."parent_id" = "owner"."id") AND ("p"."owner_id" = "owner"."id") AND ("t"."parent_id" = "owner"."id") GROUP BY "p"."owner_id", "pet"."owner_id", "thing"."parent_id", "t"."parent_id""#)
    }

    @Test
    func testDates() {
        var serializer = SQLSerializer.test
        let p = Pet.as("p")
        let date1 = DateComponents(calendar: .current, timeZone: TimeZone(identifier: "UTC"), year: 2020, month: 01, day: 01, hour: 01, minute: 01, second: 01).date!
        let date2 = DateComponents(calendar: .current, timeZone: TimeZone(identifier: "UTC"), year: 2020, month: 01, day: 30, hour: 01, minute: 01, second: 01).date!

        let b = QUERY {
            SELECT {
                Pet.$createdAt
                p.$createdAt.as(PSQLDate.self)
            }
            WHERE {
                p.$createdAt >< PSQLRange(from: date1.psqlDate, to: date2.psqlTimestamp)
                p.$createdAt >< PSQLRange(from: date1.psqlDate, to: date2.psqlDate)
            }
            GROUPBY {
                p.$createdAt
            }
        }

        b.serialize(to: &serializer)
        #expect(serializer.sql == #"SELECT "pet"."created_at"::TIMESTAMP, "p"."created_at"::DATE WHERE ("p"."created_at" BETWEEN '2020-01-01' AND '2020-01-30 01:01 AM') AND ("p"."created_at" BETWEEN '2020-01-01' AND '2020-01-30') GROUP BY "p"."created_at""#)
    }
}
