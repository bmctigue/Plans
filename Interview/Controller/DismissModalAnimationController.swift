//
//  DismissModalAnimationController.swift
//  Interview
//
//  Created by NoDeveloper on 7/29/16.
//  Copyright © 2016 NoCompany. All rights reserved.
//

import UIKit

class DismissModalAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)

        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            let bounds = UIScreen.mainScreen().bounds
            fromViewController.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: bounds.size.height)
            }, completion: {
                finished in
                transitionContext.completeTransition(true)
        })
    }

}
