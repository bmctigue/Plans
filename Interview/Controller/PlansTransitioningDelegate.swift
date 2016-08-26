//
//  PlansTransitioningDelegate.swift
//  Interview
//
//  Created by Bruce McTigue on 8/26/16.
//  Copyright © 2016 Clutter. All rights reserved.
//

import UIKit

class PlansTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    let presentModalAnimationController = PresentModalAnimationController()
    let dismissModalAnimationController = DismissModalAnimationController()

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentModalAnimationController
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissModalAnimationController
    }

}
