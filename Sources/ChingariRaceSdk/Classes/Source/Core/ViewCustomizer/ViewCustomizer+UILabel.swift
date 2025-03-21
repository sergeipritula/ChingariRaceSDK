//
//  ViewCustomizer+UILabel.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 03.06.2021.
//

import Foundation
import UIKit

// swiftlint:disable implicitly_unwrapped_optional
internal extension ViewCustomizer where ViewType: UILabel {
    
    @available(*, deprecated, message: "Consider using set(font: CHFont).")
    @discardableResult
    func set(font: UIFont) -> Self {
        view?.font = font
        return self
    }
    
    @discardableResult
    func set(font: CHFont) -> Self {
        view?.font = font.uiFont
        return self
    }
    
    @discardableResult
    func set(textColor: UIColor!, alpha: CGFloat? = nil) -> Self {
        view?.textColor = textColor.alpha(alpha)
        return self
    }

    @discardableResult
    func set(numberOfLines: Int) -> Self {
        view?.numberOfLines = numberOfLines
        return self
    }

    @discardableResult
    func setMultiline() -> Self {
        view?.numberOfLines = 0
        return self
    }

    @discardableResult
    func set(textAlignment: NSTextAlignment) -> Self {
        view?.textAlignment = textAlignment
        return self
    }

    @discardableResult
    func set(lineBreakMode: NSLineBreakMode) -> Self {
        view?.lineBreakMode = lineBreakMode
        return self
    }

    @discardableResult
    func set(minimumScaleFactor: CGFloat) -> Self {
        view?.adjustsFontSizeToFitWidth = true
        view?.minimumScaleFactor = minimumScaleFactor
        return self
    }
    
    @discardableResult
    func set(text: String?) -> Self {
        view?.text = text
        return self
    }
}

// swiftlint:enable implicitly_unwrapped_optional
