//
//  PlannableProtocol.swift
//  Interview
//
//  Created by NoDeveloper on 7/28/16.
//  Copyright © 2016 NoCompany. All rights reserved.
//

import Foundation
import UIKit

protocol Plannable {}

extension Plannable {

    func setAmountForPlanInRegion(plan: Plan, region: Int) -> Plan {
        var plan = plan
        for pricing in plan.pricings {
            if (pricing.regions.contains(region)) {
                plan.amount = pricing.amount
                break
            }
        }
        return plan
    }

    func updatePlansWithAmount(plans: [Plan], region: Int) -> [Plan] {
        return plans.map({setAmountForPlanInRegion($0, region: region)})
    }

    func sortedPlansByAmount(plans:[Plan]) -> [Plan] {
        var plans: [Plan] = plans
        plans.sortInPlace({Double($0.amount) > Double($1.amount)})
        return plans
    }

    func updatePlanSelection(stepperValue: Int, planName: String, plansCountHash: [String:Int]) -> [String:Int] {
        var plansCountHash:[String:Int] = plansCountHash
        if stepperValue == 0 {
            plansCountHash.removeValueForKey(planName)
        } else {
            plansCountHash[planName] = stepperValue
        }
        return plansCountHash
    }

    func tableTitleFromPlanNames(planNames: [String], plansCountHash: [String:Int]) -> String {
        var countStringArray: [String] = []
        var planString: String
        for key in planNames {
            if let planCount = plansCountHash[key] {
                planString = planCount == 1 ? "Plan" : "Plans"
                countStringArray.append("\(planCount) \(key) \(planString)")
            }
        }
        if countStringArray.isEmpty {
            return "$0.00 – No Plans Selected"
        }
        return countStringArray.joinWithSeparator(", ")
    }

}
