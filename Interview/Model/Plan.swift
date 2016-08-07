//
//  Plan.swift
//  Interview
//
//  Created by NoDeveloper on 7/27/16.
//  Copyright © 2016 NoCompany. All rights reserved.
//

import Foundation

let planPricingRegion = 2

struct Plan: Mappable {
    let id: Int
    let name: String
    let pricings: [Pricing]
    var amount: String

    init(map: Mapper) throws {
        try id = map.from("id")
        try name = map.from("name")
        try pricings = map.from("pricings")
        amount = ""
    }
}

extension Plan: Equatable {}

func ==(lhs: Plan, rhs: Plan) -> Bool { // swiftlint:disable:this operator_whitespace
    return lhs.id == rhs.id
}

struct Pricing: Mappable {
    let id: Int
    let amount: String
    let regions: [Int]

    init(map: Mapper) throws {
        try id = map.from("id")
        try amount = map.from("amount")
        try regions = map.from("regions")
    }
}

extension Pricing: Equatable {}

func ==(lhs: Pricing, rhs: Pricing) -> Bool { // swiftlint:disable:this operator_whitespace
    return lhs.id == rhs.id
}

struct Plans: Mappable {
    let plans: [Plan]

    init(map: Mapper) throws {
        try plans = map.from("plans")
    }
}
