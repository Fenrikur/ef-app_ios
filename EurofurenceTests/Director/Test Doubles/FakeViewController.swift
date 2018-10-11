//
//  FakeViewController.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

class FakeViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        restorationIdentifier = .random
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private(set) var capturedPresentedViewController: UIViewController?
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        capturedPresentedViewController = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    private(set) var didDismissViewController = false
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        didDismissViewController = true
        super.dismiss(animated: flag, completion: completion)
    }

}
