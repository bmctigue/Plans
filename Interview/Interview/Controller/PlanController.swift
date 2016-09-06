//
//  PlanController.swift
//  Interview
//
//  Created by NoDeveloper on 7/27/16.
//  Copyright © 2016 NoCompany. All rights reserved.
//

import Foundation

let planNotificationKey = "com.tiguer.plansLoadedNotificationKey"
let plansUrlString = "https://api.myjson.com/bins/5431j"
let planPricingRegion = 2

final class PlanController: Plannable, DownloadServicesDelegate {

    static let sharedInstance = PlanController()
    private init() {}

    struct Items {
        private(set) static var all:[Plan] = []
        private(set) static var sortedByAmount:[Plan] = []
    }

    func processJson(json: Dictionary<String,NSArray>) {
        if let plans = Plans.from(json) {
            Items.all = updatePlansWithAmount(plans.plans, region: planPricingRegion)
            Items.sortedByAmount = sortedPlansByAmount(Items.all)
            let notification = NSNotification(name: planNotificationKey, object: nil)
            NSNotificationCenter.defaultCenter().postNotification(notification)
        }
    }

    func downloadPlans(planUrlString: String) {
        let downloadService = DownloadServices(urlString: plansUrlString, delegate: self)
        let downloadCommand = DownloadCommand.init(downloadService: downloadService)
        downloadCommand.execute()
    }

    func downLoadFinished(jsonArray: NSArray) {
        let json = ["plans":jsonArray]
        self.processJson(json)
    }
}
