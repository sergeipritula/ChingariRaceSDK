//
//  ViewCustomizer+UIView.swift
//  ViewCustomizer
//
//  Created by Vorko Dmitriy on 03.06.2021.
//

import Foundation
import UIKit

// swiftlint:disable implicitly_unwrapped_optional

public extension ViewCustomizer where ViewType: UIView {

    @discardableResult
    func set(backgroundColor: UIColor?, alpha: CGFloat? = nil) -> Self {
        view?.backgroundColor = backgroundColor?.alpha(alpha)
        return self
    }
    
    @discardableResult
    func setClearBackground() -> Self {
        return set(backgroundColor: .clear)
    }

    @discardableResult
    func set(clipsToBounds: Bool) -> Self {
        view?.clipsToBounds = clipsToBounds
        return self
    }

    @discardableResult
    func set(contentMode: UIView.ContentMode) -> Self {
        view?.contentMode = contentMode
        return self
    }

    @discardableResult
    func set(tintColor: UIColor?, alpha: CGFloat? = nil) -> Self {
        view?.tintColor = tintColor?.alpha(alpha)
        return self
    }

    @discardableResult
    func set(isHidden: Bool) -> Self {
        view?.isHidden = isHidden
        return self
    }

    @discardableResult
    func set(isUserInteractionEnabled: Bool) -> Self {
        view?.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }

    // MARK: - Layers

    @discardableResult
    func set(masksToBounds: Bool) -> Self {
        view?.layer.masksToBounds = masksToBounds
        return self
    }

    @discardableResult
    func set(cornerRadius: CGFloat) -> Self {
        view?.layer.cornerRadius = cornerRadius
        return self
    }

    @discardableResult
    func set(maskedCorners: CACornerMask) -> Self {
        view?.layer.maskedCorners = maskedCorners
        return self
    }
    
    @discardableResult
    func set(borderWidth: CGFloat, borderColor: UIColor?) -> Self {
        return set(borderWidth: borderWidth)
            .set(borderColor: borderColor)
    }

    @discardableResult
    func set(borderWidth: CGFloat) -> Self {
        view?.layer.borderWidth = borderWidth
        return self
    }

    @discardableResult
    func set(borderColor: UIColor?, alpha: CGFloat? = nil) -> Self {
        view?.layer.borderColor = borderColor?.alpha(alpha).cgColor
        return self
    }
    
    @discardableResult
    func set(alpha: CGFloat) -> Self {
        view?.alpha = alpha
        return self
    }

    @discardableResult
    func set(tag: Int) -> Self {
        view?.tag = tag
        return self
    }
    
    @discardableResult
    func set(semanticContentAttribute: UISemanticContentAttribute) -> Self {
        view?.semanticContentAttribute = semanticContentAttribute
        return self
    }
}

// swiftlint:enable implicitly_unwrapped_optional

extension UIColor {
    
    func alpha(_ alpha: CGFloat?) -> UIColor {
        guard let alpha else { return self }
        return withAlphaComponent(alpha)
    }
}
