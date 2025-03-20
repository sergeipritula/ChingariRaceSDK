//
//  UILabel+TextHeightCalc.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 12.05.2021.
//  Copyright © 2020 Dmitriy Vorko. All rights reserved.
//

import UIKit

// MARK: - Public ext

public extension UILabel {
    /// Returns the height of the text at a given width
    func textHeight(withWidth width: CGFloat) -> CGFloat {
        guard let text = text else {
            return 0
        }
        return text.height(withWidth: width, font: font)
    }

    /// Returns the height of the attributed text at a given width
    func attributedTextHeight(withWidth width: CGFloat) -> CGFloat {
        guard let attributedText = attributedText else {
            return 0
        }
        return attributedText.height(withWidth: width)
    }
    
    func labelHeight(width: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    func highlightWords(wordsToHighlight: [String], color: UIColor, fromStart: Bool = false) {
        guard let text = self.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        
        for word in wordsToHighlight {
            let range = (text.lowercased() as NSString).range(of: word.lowercased())
            if range.location != NSNotFound {
                if fromStart == true && range.location == .zero || fromStart == false {
                    attributedString.addAttribute(.foregroundColor, value: color, range: range)
                }
            }
        }
        
        self.attributedText = attributedString
    }
}
