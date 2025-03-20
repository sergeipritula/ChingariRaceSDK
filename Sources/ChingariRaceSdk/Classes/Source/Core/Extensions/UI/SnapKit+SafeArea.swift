// swiftlint:disable:this file_name
//  SnapKit+SafeArea.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 12.05.2021.
//  Copyright © 2020 Dmitriy Vorko. All rights reserved.
//

import UIKit
import SnapKit

internal extension SnapKit.ConstraintMakerExtendable {
    @discardableResult
    func equalToSafeBottom(of viewController: UIViewController) -> SnapKit.ConstraintMakerEditable {
        if #available(iOS 11.0, *) {
            return bottom.equalTo(viewController.view.safeAreaLayoutGuide.snp.bottom)
        } else {
            return bottom.equalTo(viewController.bottomLayoutGuide.snp.top)
        }
    }

    @discardableResult
    func equalToSafeTop(of viewController: UIViewController) -> SnapKit.ConstraintMakerEditable {
        if #available(iOS 11.0, *) {
            return top.equalTo(viewController.view.safeAreaLayoutGuide.snp.top)
        } else {
            return top.equalTo(viewController.topLayoutGuide.snp.bottom)
        }
    }

    @available(iOS 11.0, *)
    @discardableResult
    func equalToSafe(of viewController: UIViewController) -> SnapKit.ConstraintMakerEditable {
        return equalTo(viewController.view.safeAreaLayoutGuide)
    }
}

internal extension UIView {
    var safeArea: ConstraintBasicAttributesDSL {
        #if swift(>=3.2)
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.snp
            }
            return snp
        #else
            return snp
        #endif
    }
}
