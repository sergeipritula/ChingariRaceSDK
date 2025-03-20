//
//  ViewCustomizer+UIButton.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 03.06.2021.
//

import Foundation
import UIKit

public extension ViewCustomizer where ViewType: UIButton {
    
    @discardableResult
    func set(normalTitleColor: UIColor?, for state: UIControl.State = .normal) -> Self {
        view?.setTitleColor(normalTitleColor, for: state)
        return self
    }
    
    @available(*, deprecated, message: "Consider using set(font: CHFont).")
    @discardableResult
    func set(font: UIFont) -> Self {
        view?.titleLabel?.font = font
        return self
    }
    
    @discardableResult
    func set(font: CHFont) -> Self {
        view?.titleLabel?.font = font.uiFont
        return self
    }
    
    @discardableResult
    func set(image: UIImage?, for state: UIControl.State = .normal) -> Self {
        view?.setImage(image, for: state)
        return self
    }
    
    @discardableResult
    func setSelected(image: UIImage?) -> Self {
        view?.setImage(image, for: .selected)
        return self
    }
    
    @discardableResult
    func set(isHighlighted: Bool) -> Self {
        view?.isHighlighted = isHighlighted
        return self
    }

    @discardableResult
    func set(imageContentMode: UIView.ContentMode) -> Self {
        view?.imageView?.contentMode = imageContentMode
        return self
    }
    
    @discardableResult
    func set(textAlignment: NSTextAlignment) -> Self {
        view?.titleLabel?.textAlignment = textAlignment
        return self
    }
    
    
    @discardableResult
    func set(titleContentMode: UIView.ContentMode) -> Self {
        view?.titleLabel?.contentMode = titleContentMode
        return self
    }

    @discardableResult
    func set(imageEdgeInsets: UIEdgeInsets) -> Self {
        view?.imageEdgeInsets = imageEdgeInsets
        return self
    }

    @discardableResult
    func set(imageEdgeInsets: CGFloat) -> Self {
        view?.imageEdgeInsets = .init(
            top: imageEdgeInsets,
            left: imageEdgeInsets,
            bottom: imageEdgeInsets,
            right: imageEdgeInsets
        )
        return self
    }
    
    @discardableResult
    func set(titleEdgeInsets: UIEdgeInsets) -> Self {
        view?.titleEdgeInsets = titleEdgeInsets
        return self
    }
    
    @discardableResult
    func set(contentEdgeInsets: UIEdgeInsets) -> Self {
        view?.contentEdgeInsets = contentEdgeInsets
        return self
    }
    
    @discardableResult
    func set(isEnabled: Bool) -> Self {
        view?.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    func set(title: String?, for state: UIControl.State = .normal) -> Self {
        view?.setTitle(title, for: state)
        return self
    }
    
    @discardableResult
    func set(attributedTitle: NSAttributedString) -> Self {
        view?.setAttributedTitle(attributedTitle, for: .normal)
        return self
    }
    
    @discardableResult
    func set(numberOfLines: Int) -> Self {
        view?.titleLabel?.numberOfLines = numberOfLines
        return self
    }
    
    @discardableResult
    func set(lineBreakMode: NSLineBreakMode) -> Self {
        view?.titleLabel?.lineBreakMode = lineBreakMode
        return self
    }
    
    @discardableResult
    func set(backgroundImage: UIImage?, for state: UIControl.State = .normal) -> Self {
        view?.setBackgroundImage(backgroundImage, for: state)
        return self
    }

}
