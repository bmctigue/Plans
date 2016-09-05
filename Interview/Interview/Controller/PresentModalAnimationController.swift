//
//  PresentModalAnimationController.swift
//  Interview
//
//  Created by NoDeveloper on 7/29/16.
//  Copyright © 2016 NoCompany. All rights reserved.
//

import UIKit

class PresentModalAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
        let containerView = transitionContext.containerView()
        let bounds = UIScreen.mainScreen().bounds
        toViewController.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: bounds.size.height)
        containerView!.addSubview(toViewController.view)

        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            toViewController.view.frame = finalFrameForVC
            }, completion: {
                finished in
                transitionContext.completeTransition(true)
        })
    }

}
