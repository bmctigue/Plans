//
//  PlanCell.swift
//  Interview
//
//  Created by NoDeveloper on 7/28/16.
//  Copyright © 2016 NoCompany. All rights reserved.
//

import UIKit

protocol PlanCellDelegate: class {
    func stepperButtonPressed(stepper: UIStepper, planName:String)
}

class PlanCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var planTotalStepper: UIStepper!

    weak var delegate: PlanCellDelegate?
    var plan: Plan?

    func updateCellWithPlan(plan: Plan) {
        self.plan = plan
        nameLabel.text = plan.name
        amountLabel.text = "$\(plan.amount) / month"
    }

    @IBAction func stepperPressed(sender: AnyObject) {
        let stepper = sender as! UIStepper
        delegate?.stepperButtonPressed(stepper, planName: plan!.name)
    }

}
