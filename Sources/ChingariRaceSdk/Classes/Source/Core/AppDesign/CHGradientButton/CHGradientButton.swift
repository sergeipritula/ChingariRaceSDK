//
//  CHGradientButton.swift
//  AppDesign
//
//  Created by Andrey Krit on 02.03.2023.
//

import Foundation
import UIKit

public class CHGradientButton: UIButton {
    
    private let gradientView: CHGradientView
    
    public init(model: CHGradientModel? = nil,
                borderModel: CHBorderGradientModel? = nil,
                shadowModel: CHShadowModel? = nil,
                cornerRadius: CGFloat? = nil,
                corners: UIRectCorner? = nil) {
        gradientView = CHGradientView(model: model,
                                      borderModel: borderModel,
                                      shadowModel: shadowModel,
                                      cornerRadius: cornerRadius,
                                      corners: corners)
        super.init(frame: .zero)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        gradientView = CHGradientView()
        super.init(coder: coder)
        setupConstraints()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !(subviews.first is CHGradientView) {
            insertSubview(gradientView, at: 0)
        }
    }
    
    private func setupConstraints() {
        gradientView.isUserInteractionEnabled = false
        insertSubview(gradientView, at: 0)
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public func update(cornerRadius: CGFloat? = nil, corners: UIRectCorner? = nil) {
        gradientView.update(cornerRadius: cornerRadius, corners: corners)
    }
    
    public func updateShadowView(model: CHShadowModel?) {
        gradientView.updateShadowView(model: model)
    }
    
    public func updateGradientView(model: CHGradientModel?) {
        gradientView.updateGradientView(model: model)
    }
    
    public func updateBorderGradientView(model: CHBorderGradientModel?) {
        gradientView.updateBorderGradientView(model: model)
    }
}
