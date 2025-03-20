//
//  TableViewCell.swift
//  AppDesign
//
//  Created by Vorko Dmitriy on 13.05.2021.
//

import Foundation
import RxSwift
import UIKit

open class TableViewCell: UITableViewCell {
    // MARK: - Properties

    public lazy var disposeBag = DisposeBag()

    // MARK: - Constructor

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        setupView()
        setupLocalization()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
        setupView()
        setupLocalization()
    }
    
    

    // MARK: - Fucntions

    open func setupView() {}

    open func setupConstraints() {}

    open func setupLocalization() {}
}
