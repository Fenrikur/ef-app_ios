//
//  UIStoryboard+Convenience.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIStoryboard
import UIKit.UIViewController

extension UIStoryboard {

    func instantiate<T>(_ viewControllerType: T.Type) -> T where T : UIViewController {
        let identifier = String(describing: T.self)
        guard let viewController = instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Unable to instantiate view controller \(T.self) using its name")
        }

        return viewController
    }

}
