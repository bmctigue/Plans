//
//  PlansTableViewController.swift
//  Interview
//
//  Created by NoDeveloper on 7/28/16.
//  Copyright © 2016 NoCompany. All rights reserved.
//

import UIKit

class PlansTableViewController: UITableViewController, Plannable, PlanCellDelegate, ModalDelegate, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var titleLabel: UILabel!

    var plans:[Plan] = []
    var plansCountHash: [String:Int] = [:]
    let presentModalAnimationController = PresentModalAnimationController()
    let dismissModalAnimationController = DismissModalAnimationController()
    var toViewController: ModalViewController = ModalViewController()
    let alphaView: UIView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(PlansTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)

        addAlphaView()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlansTableViewController.plansLoaded(_:)), name: planNotificationKey, object: nil)
    }

    func addAlphaView() {
        alphaView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height)
        alphaView.alpha = 0.0
        alphaView.backgroundColor = UIColor.blackColor()
        self.navigationController?.view.addSubview(alphaView)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        PlansFetcher.sharedInstance.downloadPlans()
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        PlansFetcher.sharedInstance.downloadPlans()
        refreshControl.endRefreshing()
    }

    func plansLoaded(notification:NSNotification) {
        plans = PlansFetcher.FetcherPlans.plans
        self.tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:PlanCell = tableView.dequeueReusableCellWithIdentifier("PlanCell", forIndexPath: indexPath) as! PlanCell
        let plan = plans[indexPath.row]
        cell.delegate = self
        cell.updateCellWithPlan(plan)
        return cell
    }

    func stepperButtonPressed(stepper: UIStepper, plan:Plan) {
        plansCountHash = updatePlanSelection(Int(stepper.value), plan: plan, plansCountHash:plansCountHash)
        titleLabel.text = self.tableTitleFromPlans(sortedPlansByAmount(PlansFetcher.FetcherPlans.sortedPlansByAmount), plansCountHash: plansCountHash)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showModal" {
            toViewController = segue.destinationViewController as! ModalViewController
            toViewController.delegate = self
            toViewController.transitioningDelegate = self
            UIView.animateWithDuration(0.5, animations: {
                self.alphaView.alpha = 0.4
            })
        }
    }

    func dismissButtonPressed(sender: AnyObject) {
        UIView.animateWithDuration(0.5, animations: {
            self.alphaView.alpha = 0.0
        })
        toViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentModalAnimationController
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissModalAnimationController
    }

    deinit {
        self.removeObserver(self, forKeyPath: planNotificationKey)
    }

}
