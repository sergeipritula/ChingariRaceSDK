//
//  NSMutableAtrributedString+Extension.swift
//  Extensions
//
//  Created by Pavan on 27/06/23.
//

import UIKit

public extension NSMutableAttributedString {
    func applyBold(to text: String, withFont font: UIFont = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)) {
        let range = self.mutableString.range(of: text)
        self.addAttribute(.font, value: font, range: range)
    }
     
    func applyLineSpacing(_ lineSpacing: CGFloat = 1.0, alignment: NSTextAlignment = .left) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        self.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: self.length))
    }
    
    func insertImage(_ image: UIImage?, after substring: String) {
        guard let image else { return }
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image

        if let font = self.attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
            let imageSize = font.pointSize
            imageAttachment.bounds = CGRect(x: 0, y: -4, width: imageSize, height: imageSize)
        }

        let imageAttributedString = NSAttributedString(attachment: imageAttachment)
        let range = self.mutableString.range(of: substring)
        self.insert(imageAttributedString, at: range.upperBound)
    }
}

