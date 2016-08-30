//
//  PlansTableViewDataSource.swift
//  Interview
//
//  Created by NoDeveloper on 8/26/16.
//  Copyright © 2016 NoCompany. All rights reserved.
//

import UIKit

class PlansTableViewDataSource: NSObject, PlanCellDelegate {

    let titleLabel: UILabel
    var plansCountHash: [String:Int] = [:]

    init(tableView: UITableView, titleLabel: UILabel) {
        self.titleLabel = titleLabel
        super.init()
        tableView.dataSource = self
    }

    func stepperButtonPressed(stepper: UIStepper, planName:String) {
        plansCountHash = updatePlanSelection(Int(stepper.value), planName: planName, plansCountHash:plansCountHash)
        let sortedPlanNamesByAmount = StateController.Items.sortedByAmount.map({$0.name})
        titleLabel.text = self.tableTitleFromPlanNames(sortedPlanNamesByAmount, plansCountHash: plansCountHash)
    }
}

extension PlansTableViewDataSource: UITableViewDataSource, Plannable {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StateController.Items.all.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:PlanCell = tableView.dequeueReusableCellWithIdentifier("PlanCell", forIndexPath: indexPath) as! PlanCell
        cell.delegate = self
        return cell
    }

}
