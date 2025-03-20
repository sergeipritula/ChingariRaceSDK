//
//  UIView+extensions.swift
//  Extensions
//
//  Created by Slava Leschenko on 24.11.2021.
//

import UIKit

public extension UIView {
    func asImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        drawHierarchy(in: frame, afterScreenUpdates: true)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
