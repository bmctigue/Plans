//
//  PlansFetcher.swift
//  Interview
//
//  Created by Bruce McTigue on 8/7/16.
//  Copyright © 2016 Clutter. All rights reserved.
//

import Foundation

let planNotificationKey = "com.tiguer.plansLoadedNotificationKey"
let plansUrlString = "https://api.myjson.com/bins/5431j"
let planPricingRegion = 2

final class PlansFetcher: Plannable {

    static let sharedInstance = PlansFetcher()
    private init() {}

    struct FetcherPlans {
        private(set) static var plans:[Plan] = []
        private(set) static var sortedPlansByAmount:[Plan] = []
    }

    func planRequest(planUrlString: String, method: String) -> NSURLRequest {
        let planUrl = NSURL(string:planUrlString)
        let request = NSMutableURLRequest(URL:planUrl!)
        request.HTTPMethod = method
        return request
    }

    func processJson(json: Dictionary<String,NSArray>) {
        if let plans = Plans.from(json) {
            FetcherPlans.plans = updatePlansWithAmount(plans.plans, region: planPricingRegion)
            FetcherPlans.sortedPlansByAmount = sortedPlansByAmount(FetcherPlans.plans)
            let notification = NSNotification(name: planNotificationKey, object: nil)
            dispatch_async(dispatch_get_main_queue(), {
                NSNotificationCenter.defaultCenter().postNotification(notification)
            })
        }
    }

    func downloadPlans(planUrlString: String) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(planRequest(planUrlString, method: "GET")) {
            data, response, error in

            // Check for error
            if error != nil {
                print("error=\(error)")
                return
            }
            do {
                if let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray {
                    let json = ["plans":jsonArray]
                    self.processJson(json)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
