//
//  СustomizerTypeProtocol.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 03.06.2021.
//

import Foundation
import UIKit

public protocol СustomizerTypeProtocol: AnyObject {}

public extension СustomizerTypeProtocol {
    var customizer: ViewCustomizer<Self> {
        return ViewCustomizer(view: self)
    }
}

extension UIView: СustomizerTypeProtocol {}
extension UIViewController: СustomizerTypeProtocol {}
