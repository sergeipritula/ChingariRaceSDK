//
//  ViewProtocol.swift
//  MVVM
//
//  Created by Vorko Dmitriy on 12.05.2021.
//

import Foundation

public protocol ViewProtocol {
    associatedtype ViewModelType: ViewModelProtocol

    // swiftlint:disable:next implicitly_unwrapped_optional
    var viewModel: ViewModelType! { get set }

    func setupOutput()
    func setupInput(input: ViewModelType.Output)
}
