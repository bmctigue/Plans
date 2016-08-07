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

    let plan1Name  = "Plan1"
    let plan2Name  = "Plan2"
    let highAmount = "300.0"
    let lowAmount  = "100.0"
    let highCount = 3
    let lowCount = 1
    let region = 2
    let plan1Hash  = ["id":1,"name":"Plan1","amount":"","pricings":[["id":3,"amount":"200.0","regions":[3]],["id":4,"amount":"100.0","regions":[2]]]]
    let plan2Hash  = ["id":2,"name":"Plan2","amount":"","pricings":[["id":5,"amount":"200.0","regions":[5]],["id":6,"amount":"300.0","regions":[2]]]]

    func testSetAmountForPlanInRegion() {
        let plan = try? Plan(map: Mapper(JSON:plan1Hash))
        let result: Plan = setAmountForPlanInRegion(plan!, region: region)
        XCTAssertEqual(result.amount, lowAmount)
    }

    func testUpdatePlansWithAmount() {
        let plan1 = try? Plan(map: Mapper(JSON:plan1Hash))
        let plan2 = try? Plan(map: Mapper(JSON:plan2Hash))
        let plans: [Plan] = [plan1!,plan2!]
        let result: [Plan] = updatePlansWithAmount(plans, region: region)
        let resultPlanFirst: Plan = result.first!
        let resultPlanLast: Plan = result.last!
        XCTAssertEqual(resultPlanFirst.amount, lowAmount)
        XCTAssertEqual(resultPlanLast.amount, highAmount)
    }

    func testSortedPlansByAmount() {
        let plan1 = try? Plan(map: Mapper(JSON:plan1Hash))
        let plan2 = try? Plan(map: Mapper(JSON:plan2Hash))
        let plans: [Plan] = [plan1!,plan2!]
        let updatedPlans: [Plan] = updatePlansWithAmount(plans, region: region)
        let result = sortedPlansByAmount(updatedPlans)
        let resultPlanFirst: Plan = result.first!
        let resultPlanLast: Plan = result.last!
        XCTAssertEqual(resultPlanFirst.amount, highAmount)
        XCTAssertEqual(resultPlanLast.amount, lowAmount)
    }

    func testUpdatePlanSelection() {
        let plansCountHash: [String:Int] = [:]
        let result: [String:Int] = updatePlanSelection(highCount, planName: plan1Name, plansCountHash: plansCountHash)
        XCTAssertEqual(result[plan1Name], highCount)
    }

    func testUpdatePlanSelectionZeroCount() {
        let plansCountHash: [String:Int] = [plan1Name:highCount]
        let result: [String:Int] = updatePlanSelection(0, planName: plan1Name, plansCountHash: plansCountHash)
        XCTAssertEqual(result, [:])
    }

    func testTableTitleFromPlanNamesNoPlansAdded() {
        let planNames: [String] = [plan1Name,plan2Name]
        let plansCountHash: [String:Int] = [:]
        let result: String = tableTitleFromPlanNames(planNames, plansCountHash: plansCountHash)
        XCTAssertEqual(result, "$0.00 – No Plans Selected")
    }

    func testTableTitleFromPlanNames() {
        let planNames: [String] = [plan2Name,plan1Name]
        let plansCountHash: [String:Int] = [plan1Name:highCount,plan2Name:lowCount]
        let result: String = tableTitleFromPlanNames(planNames, plansCountHash: plansCountHash)
        print (result)
        XCTAssertEqual(result, "\(lowCount) \(plan2Name) Plan, \(highCount) \(plan1Name) Plans")
    }
}
