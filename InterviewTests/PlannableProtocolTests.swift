//
//  PlannableProtocolTests.swift
//  Interview
//
//  Created by NoDeveloper on 7/29/16.
//  Copyright © 2016 NoCompany. All rights reserved.
//

import XCTest
@testable import Interview

class PlannableProtocolTests: XCTestCase, Plannable {

    let plan1Hash = ["name":"Plan1","amount":"","pricings":[["amount":"200.0","regions":[3]],["amount":"100.0","regions":[2]]]]
    let plan2Hash = ["name":"Plan2","amount":"","pricings":[["amount":"200.0","regions":[5]],["amount":"300.0","regions":[2]]]]

    func testSetAmountForPlanInRegion() {
        let plan = try? Plan(map: Mapper(JSON:plan1Hash))
        let result: Plan = setAmountForPlanInRegion(plan!, region: 2)
        XCTAssertEqual(result.amount, "100.0")
    }

    func testUpdatePlansWithAmount() {
        let plan1 = try? Plan(map: Mapper(JSON:plan1Hash))
        let plan2 = try? Plan(map: Mapper(JSON:plan2Hash))
        let plans: [Plan] = [plan1!,plan2!]
        let result: [Plan] = updatePlansWithAmount(plans, region: 2)
        let resultPlanFirst: Plan = result.first!
        let resultPlanLast: Plan = result.last!
        XCTAssertEqual(resultPlanFirst.amount, "100.0")
        XCTAssertEqual(resultPlanLast.amount, "300.0")
    }

    func testSortedPlansByAmount() {
        let plan1 = try? Plan(map: Mapper(JSON:plan1Hash))
        let plan2 = try? Plan(map: Mapper(JSON:plan2Hash))
        let plans: [Plan] = [plan1!,plan2!]
        let updatedPlans: [Plan] = updatePlansWithAmount(plans, region: 2)
        let result = sortedPlansByAmount(updatedPlans)
        let resultPlanFirst: Plan = result.first!
        let resultPlanLast: Plan = result.last!
        XCTAssertEqual(resultPlanFirst.amount, "300.0")
        XCTAssertEqual(resultPlanLast.amount, "100.0")
    }

    func testUpdatePlanSelection() {
        let plan1 = try? Plan(map: Mapper(JSON:plan1Hash))
        let plansCountHash: [String:Int] = [:]
        let result: [String:Int] = updatePlanSelection(3, plan: plan1!, plansCountHash: plansCountHash)
        XCTAssertEqual(result[plan1!.name], 3)
    }

    func testUpdatePlanSelectionZeroCount() {
        let plan1 = try? Plan(map: Mapper(JSON:plan1Hash))
        let plansCountHash: [String:Int] = [plan1!.name:3]
        let result: [String:Int] = updatePlanSelection(0, plan: plan1!, plansCountHash: plansCountHash)
        XCTAssertEqual(result, [:])
    }

    func testTableTitleFromPlansNoPlansAdded() {
        let plan1 = try? Plan(map: Mapper(JSON:plan1Hash))
        let plan2 = try? Plan(map: Mapper(JSON:plan2Hash))
        let plans: [Plan] = [plan1!,plan2!]
        let plansCountHash: [String:Int] = [:]
        let result: String = tableTitleFromPlans(plans, plansCountHash: plansCountHash)
        XCTAssertEqual(result, "$0.00 – No Plans Selected")
    }

    func testTableTitleFromPlans() {
        let plan1 = try? Plan(map: Mapper(JSON:plan1Hash))
        let plan2 = try? Plan(map: Mapper(JSON:plan2Hash))
        let plans: [Plan] = [plan1!,plan2!]
        let updatedPlans: [Plan] = updatePlansWithAmount(plans, region: 2)
        let sortedPlans = sortedPlansByAmount(updatedPlans)
        let plansCountHash: [String:Int] = [plan1!.name:3,plan2!.name:1]
        let result: String = tableTitleFromPlans(sortedPlans, plansCountHash: plansCountHash)
        print (result)
        XCTAssertEqual(result, "1 \(plan2!.name) Plan, 3 \(plan1!.name) Plans")
    }
}
