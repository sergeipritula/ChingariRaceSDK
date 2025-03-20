//
//  CHRoundedGradientButton.swift
//  Pods
//
//  Created by Sergey Pritula on 27.02.2023.
//

import UIKit

public class CHRoundedGradientButton: UIButton {
    public var radius: CGFloat = 0 {
        didSet { self.layoutIfNeeded() }
    }
    
    public var gradientColors: [UIColor] = [.red, .orange, .yellow] {
        didSet { self.layoutIfNeeded() }
    }
    
    public var colorBorder: UIColor = .clear {
        didSet { self.layoutIfNeeded() }
    }
    
    public var widthBorder: CGFloat = 0 {
        didSet { self.layoutIfNeeded() }
    }
    
    private var gradientLayer: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if gradientLayer != nil {
            gradientLayer.removeFromSuperlayer()
        }
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        gradientLayer.cornerRadius = radius
        layer.insertSublayer(gradientLayer, at: 0)
        layer.masksToBounds = true
        
        layer.borderColor = colorBorder.cgColor
        layer.borderWidth = widthBorder
    }
}
