//
//  UI+addActivityIndicator.swift
//  ChingariRaceTest
//
//  Created by Sergey Pritula on 18.03.2025.
//

import UIKit

extension UIViewController {
    func addCenterActivityView(_ subview: CustomActivityIndicator, color: UIColor = UIColor(red: 0.149, green: 0.055, blue: 0.18, alpha: 0.5)) {
        subview.setup(color: color)
        self.view.addSubview(subview)
        subview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension UIView {
    func addCenterActivityView(_ subview: CustomActivityIndicator, color: UIColor = UIColor(red: 0.149, green: 0.055, blue: 0.18, alpha: 0.5)) {
        subview.setup(color: color)
        self.addSubview(subview)
        subview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
