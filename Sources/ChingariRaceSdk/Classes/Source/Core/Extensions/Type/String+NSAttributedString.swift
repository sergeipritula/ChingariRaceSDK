//
// String+NSAttributedString.swift
// Pods
//
//  Created by Vorko Dmitriy on 12.05.2021.
// Copyright © 2020.  All rights reserved.

import UIKit

public extension String {
    func attributed(with attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    func mutableAttributed(with attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
}

public extension NSTextAttachment {
    static func getCenteredImageAttachment(with imageName: String, font: UIFont?) -> NSTextAttachment {
        let imageAttachment = NSTextAttachment()
        guard let image = UIImage(named: imageName, in: .module, compatibleWith: nil),
            let font = font else { return imageAttachment }

        imageAttachment.bounds = CGRect(
            x: 0,
            y: (font.capHeight - image.size.height).rounded() / 2,
            width: image.size.width,
            height: image.size.height
        )
        imageAttachment.image = image
        return imageAttachment
    }
}

public extension String {
    
    var underLineAttriburedText: NSAttributedString {
        let attributed = NSMutableAttributedString(string: self)
        attributed.addAttribute(NSAttributedString.Key.underlineStyle,
                                value: 1,
                                range: .init(location: 0, length: attributed.length))
        return attributed
    }
}


public extension NSMutableAttributedString {
    
    func strikethroughStyle(value: Int) {
        addAttribute(.strikethroughStyle, value: value, range: NSMakeRange(0, length))
    }
}
