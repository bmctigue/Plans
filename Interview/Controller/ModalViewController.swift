//
//  ModalViewController.swift
//  Interview
//
//  Created by NoDeveloper on 7/29/16.
//  Copyright © 2016 NoCompany. All rights reserved.
//

import UIKit

protocol ModalDelegate: class {
    func dismissButtonPressed(sender: AnyObject)
}

class ModalViewController: UIViewController {

    weak var delegate: ModalDelegate?

    @IBAction func dismissButtonPressed(sender: AnyObject) {
        delegate?.dismissButtonPressed(sender)
    }

}
