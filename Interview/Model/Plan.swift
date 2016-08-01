//
//  Plan.swift
//  Interview
//
//  Created by NoDeveloper on 7/27/16.
//  Copyright © 2016 NoCompany. All rights reserved.
//

import Foundation

let planNotificationKey = "com.tiguer.plansLoadedNotificationKey"
let plansUrl = "https://api.myjson.com/bins/5431j"
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

final class PlansFetcher: Plannable {

    static let sharedInstance = PlansFetcher()
    private init() {}

    struct FetcherPlans {
        private(set) static var plans:[Plan] = []
        private(set) static var sortedPlansByAmount:[Plan] = []
    }

    func downloadPlans() {
        let planUrl = NSURL(string:plansUrl)

        // Creaste URL Request
        let request = NSMutableURLRequest(URL:planUrl!)
        request.HTTPMethod = "GET"

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in

            // Check for error
            if error != nil {
                print("error=\(error)")
                return
            }
            do {
                if let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray {
                    let plansHash = ["plans":jsonArray]
                    if let plans = Plans.from(plansHash) {
                        FetcherPlans.plans = self.updatePlansWithAmount(plans.plans, region: planPricingRegion)
                        FetcherPlans.sortedPlansByAmount = self.sortedPlansByAmount(FetcherPlans.plans)
                        dispatch_async(dispatch_get_main_queue(), {
                            let notification = NSNotification(name: planNotificationKey, object: nil)
                            NSNotificationCenter.defaultCenter().postNotification(notification)
                        })
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
