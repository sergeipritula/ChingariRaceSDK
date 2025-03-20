//
//  UIView.swift
//  Extensions
//
//  Created by Softermii-User on 20.10.2021.
//

import UIKit

public extension UIView {
    class var identifier: String {
        String(describing: self)
    }

    class var nib: UINib {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}
