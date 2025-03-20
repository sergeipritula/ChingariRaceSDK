//
//  CHFont.swift
//  AdButler
//
//  Created by Ronak Garg on 27/02/23.
//

import Foundation
import UIKit
import SwiftUI

public struct CHFont {
    public let uiFont: UIFont
    
    public init(font: CHFontType, style: UIFont.TextStyle) {
        self.uiFont = font.uiFont(style: style)
    }
}

public enum CHFontType: String {
    case latoBold = "Lato-Bold"
    case latoRegular = "Lato-Regular"
    case robotoExtraBold = "Roboto-ExtraBold"
    case robotoExtraLight = "Roboto-ExtraLight"
    case robotoLight = "Roboto-Light"
    case robotoBold = "Roboto-Bold"
    case robotoRegular = "Roboto-Regular"
    case robotoMedium = "Roboto-Medium"
    case poppinsRegular = "Poppins-Regular"
    case poppinsExtraBold = "Poppins-ExtraBold"
    case poppinsMedium = "Poppins-Medium"
    case poppinsItalic = "Poppins-Italic"
    case poppinsBold = "Poppins-Bold"
    case poppinsSemiBold = "Poppins-SemiBold"
    case montserratRegular = "Montserrat-Regular"
    case montserratExtraBold = "Montserrat-ExtraBold"
    case montserratMedium = "Montserrat-Medium"
    case montserratBold = "Montserrat-Bold"
    case montserratSemiBold = "Montserrat-SemiBold"
    case montserratItalic = "Montserrat-Italic"
    
    func uiFont(style: UIFont.TextStyle) -> UIFont {
        guard let font = UIFont(name: rawValue, size: style.size) else {
            return UIFont.systemFont(ofSize: style.size)
        }
        return font
    }
}

extension UIFont.TextStyle {
    var size: CGFloat {
        switch self {
        case .caption2: return 11
        case .caption1: return 12
        case .footnote: return 13
        case .subheadline: return 15
        case .callout: return 16
        case .headline: return 17
        case .body: return 18
        case .title3: return 20
        case .title2: return 22
        case .title1: return 28
        case .largeTitle: return 34
        default: return 12
        }
    }
}

public extension CHFont {
    var font: Font {
        Font(self.uiFont)
    }
}
