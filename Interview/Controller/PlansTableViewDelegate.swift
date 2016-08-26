//
//  PlansTableViewDelegate.swift
//  Interview
//
//  Created by Bruce McTigue on 8/26/16.
//  Copyright © 2016 Clutter. All rights reserved.
//

import UIKit

class PlansTableViewDelegate: NSObject {

    init(tableView: UITableView) {
        super.init()
        tableView.delegate = self
    }
}

extension PlansTableViewDelegate: UITableViewDelegate {

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell:PlanCell = cell as! PlanCell
        let plan = StateController.Items.all[indexPath.row]
        cell.updateCellWithPlan(plan)
    }

}
