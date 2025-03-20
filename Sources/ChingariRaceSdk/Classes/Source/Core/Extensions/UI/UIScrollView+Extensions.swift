//
//  UIScrollView+Extensions.swift
//  ChingariRaceTest
//
//  Created by Sergey Pritula on 18.03.2025.
//

import UIKit

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        let returnValue = self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
        return returnValue
    }
    
    func checkIfNeedToLoadNext() -> Bool {
        let leftSpaceOnBottom = self.contentSize.height - self.contentOffset.y
        if leftSpaceOnBottom < (self.contentSize.height * 0.3) {
            print("/// ifNeedToLoad: TRUE")
            return true
        } else {
            print("/// ifNeedToLoad: FALSE")
            return false
        }
    }
}

extension UIScrollView {
    var isBouncing: Bool {
        var isBouncing = false
        let contentSizeHeight = contentSize.height + 100
        if contentOffset.y >= (contentSizeHeight - bounds.size.height) {
            // bottom bounce
            isBouncing = true
        } else if contentOffset.y <= contentInset.top {
            // top bounce
            isBouncing = true
        }
        
        return isBouncing
    }
}
