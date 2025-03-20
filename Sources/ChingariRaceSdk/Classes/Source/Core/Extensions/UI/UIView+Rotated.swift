//
//  UIView+Rotated.swift
//  Extensions
//
//  Created by Sergey Pritula on 03.08.2021.
//

import UIKit

public extension UIView {
    func rotate() {
        if transform == CGAffineTransform.identity {
            transform = CGAffineTransform.identity.rotated(by: .pi)
        }
    }
}
