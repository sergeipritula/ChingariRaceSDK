//
//  ViewCustomizer+UIStackView.swift
//  ViewCustomizer
//
//  Created by Vorko Dmitriy on 03.06.2021.
//

import Foundation
import UIKit

public extension ViewCustomizer where ViewType: UIStackView {
    @discardableResult
    func set(distribution: UIStackView.Distribution) -> Self {
        view?.distribution = distribution
        return self
    }
    
    @discardableResult
    func set(spacing: CGFloat) -> Self {
        view?.spacing = spacing
        return self
    }
    
    @discardableResult
    func set(alignment: UIStackView.Alignment) -> Self {
        view?.alignment = alignment
        return self
    }
    
    @discardableResult
    func set(axis: NSLayoutConstraint.Axis) -> Self {
        view?.axis = axis
        return self
    }
    
}
