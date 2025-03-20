//
//  UIVIew+StaticFactoryMethods.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 06.06.2021.
//

import Foundation
import UIKit

public extension UIView {
    /// Can use in UIStackView to simulate a spacer view
    static var spacer: UIView {
        return UIView()
    }
}
