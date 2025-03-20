//
//  UIView+GradientMasking.swift
//  AppDesign
//
//  Created by Chingari MacBook Pro 16 on 08/08/23.
//

import UIKit

extension UIView {
    
    func maskingLayer(borderWidth: CGFloat?,
                      fillColor: UIColor = .clear,
                      strokeColor: UIColor = .black,
                      lineDashPattern: [Int]? = nil,
                      path: CGPath? = nil,
                      cornerRadius: CGFloat?,
                      roundingCorners: UIRectCorner?) -> CALayer {
        
        let shape = CAShapeLayer()
        let borderWidth: CGFloat = borderWidth ?? 0
        let cornerRadius: CGFloat = cornerRadius ?? 0
        shape.lineWidth = borderWidth
        let roundedRect: CGRect
        if bounds == .zero {
            roundedRect = .zero
        } else if borderWidth > 0 {
            roundedRect = bounds.insetBy(dx: borderWidth, dy: borderWidth)
        } else {
            roundedRect = bounds
        }
        
        if let path {
            shape.path = path
        } else {
            shape.path = UIBezierPath(roundedRect: roundedRect,
                                      byRoundingCorners: roundingCorners ?? .allCorners,
                                      cornerRadii: .init(width: cornerRadius, height: cornerRadius)).cgPath
        }
        shape.strokeColor = strokeColor.cgColor
        shape.lineDashPattern = lineDashPattern?.map { .init(integerLiteral: $0) }
        shape.lineCap = .round
        shape.fillColor = fillColor.cgColor
        return shape
    }
}
