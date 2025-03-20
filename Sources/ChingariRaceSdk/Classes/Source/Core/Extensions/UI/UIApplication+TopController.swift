//
//  UIApplication+TopController.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 09.06.2021.
//

import Foundation
import UIKit

public extension UIApplication {
    func findPresentedController<T: UIViewController>() -> T? {
        guard
            let window = keyWindow,
            let rootViewController = window.rootViewController
        else {
            return nil
        }

        var topController = rootViewController
        var resultController: T?

        while
            resultController == nil,
            let newTopController = topController.presentedViewController
        {
            resultController = newTopController as? T
            topController = newTopController
        }

        return resultController
    }
}
