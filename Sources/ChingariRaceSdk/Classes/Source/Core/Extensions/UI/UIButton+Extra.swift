//
//  UIButton+Extra.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 03.06.2021.
//

import Foundation
import UIKit

public extension UIButton {
    var normalTitle: String? {
        get { title(for: .normal) }
        set { setTitle(newValue, for: .normal) }
    }
}
