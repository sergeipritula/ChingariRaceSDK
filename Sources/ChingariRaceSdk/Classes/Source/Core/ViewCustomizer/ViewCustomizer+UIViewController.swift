//
//  ViewCustomizer+UIViewController.swift
//  ViewCustomizer
//
//  Created by Vorko Dmitriy on 03.06.2021.
//

import Foundation
import UIKit

public extension ViewCustomizer where ViewType: UIViewController {
    @discardableResult
    func set(backgroundColor: UIColor?) -> Self {
        view?.view.backgroundColor = backgroundColor
        return self
    }
        
    @discardableResult
    func setClearBackground() -> Self {
        return set(backgroundColor: .clear)
    }
    
    @discardableResult
    func set(modalPresentationStyle: UIModalPresentationStyle) -> Self {
        view?.modalPresentationStyle = modalPresentationStyle
        return self
    }    
}
