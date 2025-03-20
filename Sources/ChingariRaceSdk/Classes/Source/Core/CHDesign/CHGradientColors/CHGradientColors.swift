//
//  CHGradientColors.swift
//  AdButler
//
//  Created by Andrey Krit on 02.03.2023.
//

import UIKit
import SwiftUI

public enum CHGradientColors {
    case primary
    case secondary
    case secondary1
    case tertiary1
    case tertiary2
    case tertiary3
    case surface1
    case surface2
    case custom(colors: [UIColor])
}

public extension CHGradientColors {
    
    var colors: [UIColor] {
        switch self {
        case .primary: return [UIColor].primary
        case .secondary: return [UIColor].secondary
        case .secondary1: return [UIColor].secondary1
        case .tertiary1: return [UIColor].tertiary1
        case .tertiary2: return [UIColor].tertiary2
        case .tertiary3: return [UIColor].tertiary3
        case .surface2: return [UIColor].surface2
        case .surface1: return [UIColor].surface1
        case .custom(let colors): return colors
        }
    }
    
    var swiftUIColors: [Color] {
        colors.map { Color($0) }
    }
}

fileprivate extension Array where Element == UIColor {
    
    static var primary: [UIColor] = [#colorLiteral(red: 0.4431372549, green: 0.4, blue: 0.9764705882, alpha: 1), #colorLiteral(red: 0.5882352941, green: 0.5254901961, blue: 0.9882352941, alpha: 1), #colorLiteral(red: 0.5176470588, green: 0.8274509804, blue: 1, alpha: 1)]
    
    static var secondary: [UIColor] = [#colorLiteral(red: 0.6941176471, green: 0.5450980392, blue: 0.9921568627, alpha: 1), #colorLiteral(red: 0.4078431373, green: 0.2745098039, blue: 0.9215686275, alpha: 1)]
    
    static var secondary1: [UIColor] = [#colorLiteral(red: 1, green: 0.6549019608, blue: 0.4039215686, alpha: 1), #colorLiteral(red: 0.9215686275, green: 0.2745098039, blue: 0.5450980392, alpha: 1)]
    
    static var tertiary1: [UIColor] {
        if CHThemeManager.sharedInstance.currentTheme == .dark {
            return [.chDarkslateblue, .chMeteorite]
        } else {
            return [#colorLiteral(red: 1, green: 0.9137254902, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0.968627451, green: 0.9607843137, blue: 1, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 1, alpha: 1)]
        }
    }
    
    static var tertiary2: [UIColor] = [.chAquaMarine, .chCyanGreen, .chBlueDress]
    
    static var tertiary3: [UIColor] = [#colorLiteral(red: 1, green: 0.3803921569, blue: 0.1960784314, alpha: 1), #colorLiteral(red: 1, green: 0.7215686275, blue: 0.4470588235, alpha: 1)]
    
    static var surface1: [UIColor] {
        if CHThemeManager.sharedInstance.currentTheme == .dark {
            return [UIColor.chLightPink.withAlphaComponent(0.12),
                    UIColor.chPurple.withAlphaComponent(0.12)]
        } else {
            return [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        }
    }
    
    static var surface2: [UIColor] {
        if CHThemeManager.sharedInstance.currentTheme == .dark {
            return [UIColor.chLightPink.withAlphaComponent(0.2),
                    UIColor.chPurple.withAlphaComponent(0.2)]
        } else {
            return [#colorLiteral(red: 1, green: 0.9585935473, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.9529411765, blue: 0.9764705882, alpha: 1), #colorLiteral(red: 0.9607843137, green: 0.9450980392, blue: 1, alpha: 1)]
        }
    }
}
