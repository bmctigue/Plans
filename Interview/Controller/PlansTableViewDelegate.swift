//
//  PlansTableViewDelegate.swift
//  Interview
//
//  Created by NoDeveloper on 8/26/16.
//  Copyright © 2016 NoCompany. All rights reserved.
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
