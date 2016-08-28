//
//  PlansTableViewController.swift
//  Interview
//
//  Created by NoDeveloper on 7/28/16.
//  Copyright © 2016 NoCompany. All rights reserved.
//

import UIKit

class PlansTableViewController: UITableViewController, Plannable, ModalDelegate {

    @IBOutlet weak var titleLabel: UILabel!

    var tableViewDataSource: PlansTableViewDataSource?
    var tableViewDelegate: PlansTableViewDelegate?
    var plansTransitioningDelegate: PlansTransitioningDelegate?
    var toViewController: ModalViewController = ModalViewController()
    let alphaView: UIView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(PlansTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)

        addAlphaView()

        self.tableViewDataSource = PlansTableViewDataSource(tableView: tableView, titleLabel: titleLabel)
        self.tableViewDelegate = PlansTableViewDelegate(tableView: tableView)
        self.plansTransitioningDelegate = PlansTransitioningDelegate()

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
        StateController.sharedInstance.downloadPlans(plansUrlString)
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        StateController.sharedInstance.downloadPlans(plansUrlString)
        refreshControl.endRefreshing()
    }

    func plansLoaded(notification:NSNotification) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showModal" {
            toViewController = segue.destinationViewController as! ModalViewController
            toViewController.delegate = self
            toViewController.transitioningDelegate = plansTransitioningDelegate
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

    deinit {
        self.removeObserver(self, forKeyPath: planNotificationKey)
    }

}
