//
//  SnapKit+Extra.swift
//  AppDesign
//
//  Created by Vorko Dmitriy on 13.05.2021.
//

import UIKit
import SnapKit

internal extension ConstraintMaker {
    @discardableResult
    func fromTheRight(of view: UIView) -> SnapKit.ConstraintMakerEditable {
        left.equalTo(view.snp.trailing)
    }

    @discardableResult
    func fromTheLeft(of view: UIView) -> SnapKit.ConstraintMakerEditable {
        right.equalTo(view.snp.leading)
    }

    @discardableResult
    func above(of view: UIView) -> SnapKit.ConstraintMakerEditable {
        bottom.equalTo(view.snp.top)
    }

    @discardableResult
    func below(of view: UIView) -> SnapKit.ConstraintMakerEditable {
        top.equalTo(view.snp.bottom)
    }
}
