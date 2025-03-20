//
//  CHColor.swift
//  AppDesign
//
//  Created by Ronak Garg on 27/02/23.
//

import Foundation
import UIKit

fileprivate protocol ThemeColor {
    var primary: UIColor { get }
    var primaryR: UIColor { get }
    var secondary: UIColor { get }
    var secondaryR: UIColor { get }
    var interactive: UIColor { get }
    var interactiveR: UIColor { get }
    var inlineError: UIColor { get }
    var disable: UIColor { get }
    var disableR: UIColor { get }
    var orange: UIColor { get }
    var purpleRed: UIColor { get }
    var pink: UIColor { get }
    var yellow: UIColor { get }
    var purple: UIColor { get }
    var lightPink: UIColor { get }
    var candyBlue: UIColor { get }
    var cyanBlue: UIColor { get }
    var green: UIColor { get }
    var darkSlateBlue: UIColor { get }
    var meteorite: UIColor { get }
    var blueDress: UIColor { get }
    var aquaMarine: UIColor { get }
    var cyanGreen: UIColor { get }
    var separator: UIColor { get }
    var gray: UIColor { get }
}

fileprivate extension ThemeColor {
    static func color(dark: UIColor, light: UIColor) -> UIColor {
        return UIColor{ _ in CHThemeManager.sharedInstance.currentTheme == .dark ? dark : light }
    }
}

fileprivate extension UIColor {
    static let theme: ThemeColor = ChingariTheme()
}

fileprivate struct ChingariTheme: ThemeColor {
    
    var primary = Self.color(dark: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), light: #colorLiteral(red: 0.1725490196, green: 0.137254902, blue: 0.2039215686, alpha: 1)) // white
 
    var primaryR = Self.color(dark: #colorLiteral(red: 0.1725490196, green: 0.137254902, blue: 0.2039215686, alpha: 1), light: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) // black
    
    var secondary = Self.color(dark: #colorLiteral(red: 0.9058823529, green: 0.8117647059, blue: 0.9333333333, alpha: 1), light: #colorLiteral(red: 0.3921568627, green: 0.262745098, blue: 0.5058823529, alpha: 1))
    
    var secondaryR = Self.color(dark: #colorLiteral(red: 0.3921568627, green: 0.262745098, blue: 0.5058823529, alpha: 1), light: #colorLiteral(red: 0.9058823529, green: 0.8117647059, blue: 0.9333333333, alpha: 1))
    
    var interactive = Self.color(dark: #colorLiteral(red: 0.7490196078, green: 0.6156862745, blue: 0.8549019608, alpha: 1), light: #colorLiteral(red: 0.3333333333, green: 0.1098039216, blue: 0.5333333333, alpha: 1))
    
    var interactiveR = Self.color(dark: #colorLiteral(red: 0.3333333333, green: 0.1098039216, blue: 0.5333333333, alpha: 1), light: #colorLiteral(red: 0.7490196078, green: 0.6156862745, blue: 0.8549019608, alpha: 1))
    
    var inlineError = Self.color(dark: #colorLiteral(red: 0.9647058824, green: 0.4980392157, blue: 0.462745098, alpha: 1), light: #colorLiteral(red: 0.9960784314, green: 0.4039215686, blue: 0.3607843137, alpha: 1))
    
    var disable = Self.color(dark: #colorLiteral(red: 0.5294117647, green: 0.4823529412, blue: 0.5764705882, alpha: 1), light: #colorLiteral(red: 0.6078431373, green: 0.6, blue: 0.6274509804, alpha: 1))
    
    var disableR = Self.color(dark: #colorLiteral(red: 0.6078431373, green: 0.6, blue: 0.6274509804, alpha: 1), light: #colorLiteral(red: 0.5294117647, green: 0.4823529412, blue: 0.5764705882, alpha: 1))
    
    var orange = Self.color(dark: #colorLiteral(red: 1, green: 0.3803921569, blue: 0.1960784314, alpha: 1), light: #colorLiteral(red: 1, green: 0.3803921569, blue: 0.1960784314, alpha: 1))
    
    var purpleRed = Self.color(dark: #colorLiteral(red: 0.831372549, green: 0.3568627451, blue: 1, alpha: 1), light: #colorLiteral(red: 0.831372549, green: 0.3568627451, blue: 1, alpha: 1))
    
    var pink = Self.color(dark: #colorLiteral(red: 0.9568627451, green: 0.337254902, blue: 0.5960784314, alpha: 1), light: #colorLiteral(red: 0.9568627451, green: 0.337254902, blue: 0.5960784314, alpha: 1))
    
    var yellow = Self.color(dark: #colorLiteral(red: 1, green: 0.7215686275, blue: 0.4470588235, alpha: 1), light: #colorLiteral(red: 1, green: 0.7215686275, blue: 0.4470588235, alpha: 1))
    
    var purple = Self.color(dark: #colorLiteral(red: 0.5411764706, green: 0.3607843137, blue: 0.9254901961, alpha: 1), light: #colorLiteral(red: 0.5411764706, green: 0.3607843137, blue: 0.9254901961, alpha: 1))
    
    var lightPink = Self.color(dark: #colorLiteral(red: 0.7960784314, green: 0.6039215686, blue: 0.8862745098, alpha: 1), light: #colorLiteral(red: 0.7960784314, green: 0.6039215686, blue: 0.8862745098, alpha: 1))
    
    var candyBlue = Self.color(dark: #colorLiteral(red: 0.6235294118, green: 0.9176470588, blue: 0.968627451, alpha: 1), light: #colorLiteral(red: 0.6235294118, green: 0.9176470588, blue: 0.968627451, alpha: 1))
    
    var cyanBlue = Self.color(dark: #colorLiteral(red: 0.2, green: 0.6941176471, blue: 0.862745098, alpha: 1), light: #colorLiteral(red: 0.2, green: 0.6941176471, blue: 0.862745098, alpha: 1))
    
    var green = Self.color(dark: #colorLiteral(red: 0.07450980392, green: 0.7568627451, blue: 0.6, alpha: 1), light: #colorLiteral(red: 0.07450980392, green: 0.7568627451, blue: 0.6, alpha: 1))
    
    var darkSlateBlue = Self.color(dark: #colorLiteral(red: 0.2862745098, green: 0.1921568627, blue: 0.5529411765, alpha: 1), light: #colorLiteral(red: 0.2862745098, green: 0.1921568627, blue: 0.5529411765, alpha: 1))
    
    var meteorite = Self.color(dark: #colorLiteral(red: 0.2, green: 0.1098039216, blue: 0.462745098, alpha: 1), light: #colorLiteral(red: 0.2, green: 0.1098039216, blue: 0.462745098, alpha: 1))
    
    var blueDress = Self.color(dark: #colorLiteral(red: 0.1254901961, green: 0.4470588235, blue: 0.9333333333, alpha: 1), light: #colorLiteral(red: 0.1254901961, green: 0.4470588235, blue: 0.9333333333, alpha: 1))
    
    var aquaMarine = Self.color(dark: #colorLiteral(red: 0.2117647059, green: 0.937254902, blue: 0.7176470588, alpha: 1), light: #colorLiteral(red: 0.2117647059, green: 0.937254902, blue: 0.7176470588, alpha: 1))
    
    var cyanGreen = Self.color(dark: #colorLiteral(red: 0.3058823529, green: 0.8941176471, blue: 0.7176470588, alpha: 1), light: #colorLiteral(red: 0.3058823529, green: 0.8941176471, blue: 0.7176470588, alpha: 1))
    
    var separator = Self.color(dark: #colorLiteral(red: 0.5294117647, green: 0.4823529412, blue: 0.5764705882, alpha: 1), light: #colorLiteral(red: 0.5294117647, green: 0.4823529412, blue: 0.5764705882, alpha: 1))
    
    var gray = Self.color(dark: #colorLiteral(red: 0.768627451, green: 0.7568627451, blue: 0.7843137255, alpha: 1), light: #colorLiteral(red: 0.768627451, green: 0.7568627451, blue: 0.7843137255, alpha: 1))
}

public extension UIColor {
    static var chPrimary = theme.primary
    static var chPrimaryR = theme.primaryR
    static var chSecondary = theme.secondary
    static var chSecondaryR = theme.secondaryR
    static var chInteractive = theme.interactive
    static var chInteractiveR = theme.interactiveR
    static var chInlineError = theme.inlineError
    static var chDisable = theme.disable
    static var chDisableR = theme.disableR
    static var chOrange = theme.orange
    static var chPurpleRed = theme.purpleRed
    static var chPink = theme.pink
    static var chYellow = theme.yellow
    static var chPurple = theme.purple
    static var chLightPink = theme.lightPink
    static var chCandyBlue = theme.candyBlue
    static var chCyanBlue = theme.cyanBlue
    static var chGreen = theme.green
    static var chDarkslateblue = theme.darkSlateBlue
    static var chMeteorite = theme.meteorite
    static var chBlueDress = theme.blueDress
    static var chAquaMarine = theme.aquaMarine
    static var chCyanGreen = theme.cyanGreen
    static var chSeparator = theme.separator
    static var chGray = theme.gray
}
