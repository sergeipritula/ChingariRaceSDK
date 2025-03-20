//
//  UIViewController.swift
//  Extensions
//
//  Created by Softermii-User on 20.10.2021.
//

import UIKit

public extension UIViewController {
    static func instantiateViewController<T: UIViewController>() -> T {
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(name: identifier, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T

        return viewController ?? T()
    }
}
