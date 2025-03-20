//
//  CHShadowModel.swift
//  AppDesign
//
//  Created by Chingari MacBook Pro 16 on 08/08/23.
//

import UIKit

public struct CHShadowModel {
    var type: CHShadowType?
    public var cornerRadius: CGFloat?
    var corners: UIRectCorner?
    
    public init(type: CHShadowType? = nil) {
        self.type = type
    }
    
    mutating func update(model: CHShadowModel?) {
        guard let model else { return }
        
        if let type = model.type {
            self.type = type
        }
        
        if let cornerRadius = model.cornerRadius {
            self.cornerRadius = cornerRadius
        }
        
        if let corners = model.corners {
            self.corners = corners
        }
    }
}
