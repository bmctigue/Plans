//
//  PlansFetcher.swift
//  Interview
//
//  Created by NoDeveloper on 7/27/16.
//  Copyright © 2016 NoCompany. All rights reserved.
//

import Foundation

let planNotificationKey = "com.tiguer.plansLoadedNotificationKey"
let plansUrlString = "https://api.myjson.com/bins/5431j"
let planPricingRegion = 2

final class StateController: Plannable {

    static let sharedInstance = StateController()
    private init() {}

    struct Items {
        private(set) static var all:[Plan] = []
        private(set) static var sortedByAmount:[Plan] = []
    }

    func planRequest(planUrlString: String, method: String) -> NSURLRequest {
        let planUrl = NSURL(string:planUrlString)
        let request = NSMutableURLRequest(URL:planUrl!)
        request.HTTPMethod = method
        return request
    }

    func processJson(json: Dictionary<String,NSArray>) {
        if let plans = Plans.from(json) {
            Items.all = updatePlansWithAmount(plans.plans, region: planPricingRegion)
            Items.sortedByAmount = sortedPlansByAmount(Items.all)
            let notification = NSNotification(name: planNotificationKey, object: nil)
            dispatch_async(dispatch_get_main_queue(), {
                NSNotificationCenter.defaultCenter().postNotification(notification)
            })
        }
    }

    func downloadPlans(planUrlString: String) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(planRequest(planUrlString, method: "GET")) {
            data, response, error in
            guard let data = data else { print(error?.localizedDescription); return }
            do {
                if let jsonArray = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
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
