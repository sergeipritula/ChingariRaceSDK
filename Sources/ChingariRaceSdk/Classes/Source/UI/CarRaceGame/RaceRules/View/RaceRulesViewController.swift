//
//  RaceRulesViewController.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

class RaceRulesViewController: ViewController<RaceRulesViewModel> {
    
    private(set) var dismissPublisher = PublishSubject<Void>()
    
    private let containerView = UIView()
    
    private let backButton = UIButton()
    
    private let titleLabel = UILabel()
    
    private let rulesLabel = UILabel()
    
    private let activityIndicatorView = CustomActivityIndicator()
    
    override func setupView() {
        view.backgroundColor = .clear
        containerView.backgroundColor = .white
        
        containerView.customizer
            .set(cornerRadius: 22)
            .set(maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        
        backButton.setImage(UIImage(named: CarRaceGameConstants.Images.back), for: .normal)
        backButton.contentHorizontalAlignment = .leading
        backButton.contentVerticalAlignment = .top
        
        titleLabel.customizer
            .set(font: .init(font: .poppinsBold, style: .callout))
            .set(textColor: UIColor(hexString: "#815EF2"))
            .set(textAlignment: .center)
            .set(numberOfLines: 0)
        
        rulesLabel.customizer
            .set(font: .init(font: .poppinsMedium, style: .caption1))
            .set(textColor: .black)
            .set(numberOfLines: 0)
    }
    
    override func setupConstraints() {
        view.addSubview(containerView)
        
        containerView.addSubviews([backButton, titleLabel, rulesLabel])
        
        containerView.snp.makeConstraints {
            $0.height.equalTo(470)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16) // Add inset to ensure proper layout
        }
        
        rulesLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(16)
        }
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        addCenterActivityView(activityIndicatorView)
    }
    
    override func setupLocalization() {
//        titleLabel.text = Localizationable.RaceGame.rules.localized
//        rulesLabel.text = Localizationable.RaceGame.rulesDetails.localized
        titleLabel.text = "Rule"
        rulesLabel.text =
"""
        Winning Prizes = Spending amount for the winning car
        *Dynamic odds for that car.

        Dynamic Odd = Total spending amount / Total
        spending amount of this car.

        Sometimes, a part of the prizes will be distributed to
        the host, guests, and the system.
"""
    }
    
    override func setupInput(input: RaceRulesViewModel.Output) {
        disposeBag.insert([
//            setupRulesObserving(with: input.message)
        ])
    }
    
    override func setupOutput() {
        let input = RaceRulesViewModel.Input(
            backEvent: backButton.rx.tap.asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: setupInput)
    }
    
    private func setupRulesObserving(with signal: Driver<String>) -> Disposable {
        signal
            .do(onNext: { [weak self] _ in self?.activityIndicatorView.stopAnimating() })
            .drive(rulesLabel.rx.text)
    }
}

//MARK: - PanModalPresentable

extension RaceRulesViewController: PanModalPresentable {
    var longFormHeight: PanModalHeight {
        return .contentHeight(470)
    }
    
    var showDragIndicator: Bool { false }
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    func panModalDidDismiss() {
        dismissPublisher.onNext(())
    }
}
