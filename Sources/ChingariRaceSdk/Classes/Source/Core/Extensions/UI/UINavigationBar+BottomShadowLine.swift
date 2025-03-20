//
//  UINavigationBar+BottomShadowLine.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 16.05.2021.
//

import Foundation
import UIKit

public extension UINavigationBar {
    func hideBottomHairline() {
        hairlineImageView?.isHidden = true
    }

    func showBottomHairline() {
        hairlineImageView?.isHidden = false
    }
}

private extension UIView {
    var hairlineImageView: UIImageView? {
        return hairlineImageView(in: self)
    }

    func hairlineImageView(in view: UIView) -> UIImageView? {
        if let imageView = view as? UIImageView, imageView.bounds.height <= 1.0 {
            return imageView
        }

        for subview in view.subviews {
            if let imageView = hairlineImageView(in: subview) {
                return imageView
            }
        }

        return nil
    }
}
