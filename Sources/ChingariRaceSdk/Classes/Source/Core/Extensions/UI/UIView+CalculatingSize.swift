//
//  UIView+CalculatingSize.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 31.05.2021.
//

import Foundation
import UIKit

public extension UIView {
    func calculateSize(
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) -> CGSize {
        let targetSize = CGSize(
            width: width ?? UIView.layoutFittingExpandedSize.width,
            height: height ?? UIView.layoutFittingExpandedSize.height
        )

        let horPrior: UILayoutPriority = (width == nil) ? .fittingSizeLevel : .required
        let vertPriority: UILayoutPriority = (height == nil) ? .fittingSizeLevel : .required

        return systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horPrior,
            verticalFittingPriority: vertPriority
        )
    }
}
