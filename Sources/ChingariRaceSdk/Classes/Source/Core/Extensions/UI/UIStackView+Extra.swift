//
// UIStackView+Extra.swift
// Pods
//
//  Created by Vorko Dmitriy on 12.05.2021.
// Copyright © 2020.  All rights reserved.

import UIKit

public extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0) {
        self.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
    }
}

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
