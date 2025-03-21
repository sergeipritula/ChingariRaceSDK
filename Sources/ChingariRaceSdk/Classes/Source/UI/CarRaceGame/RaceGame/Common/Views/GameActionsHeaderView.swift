//
//  GameActionsHeaderView.swift
//  chingari
//
//  Created by Sergey Pritula on 08.08.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GameActionsHeaderView: CHView {
    
    var disposeBag = DisposeBag()
    
    private let containerView = UIView()
    
    private let stackView = UIStackView()
    
    private let spacerView = UIView()
    
    private let rankButton = UIButton()
    
    private let winRateRankButton = UIButton()
    
    private let historyButton = UIButton()
    
    private let rulesButton = UIButton()
    
    private let rankSubject = PublishSubject<Void>()
    private let winRateSubject = PublishSubject<Void>()
    private let historySubject = PublishSubject<Void>()
    private let rulesSubject = PublishSubject<Void>()
    
    var rankObservable: RxObservable<Void> { rankSubject }
    var winRateObservable: RxObservable<Void> { winRateSubject }
    var historyObservable: RxObservable<Void> { historySubject }
    var rulesObservable: RxObservable<Void> { rulesSubject }
    
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupView()
        setupConstraints()
        setupBindings()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [rankButton, historyButton, rulesButton, winRateRankButton].forEach {
            $0.layer.cornerRadius = 15
        }
    }
    
    override func setupView() {
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        
        stackView.customizer
            .set(axis: .horizontal)
            .set(spacing: 12)
            .set(distribution: .fill)
            .set(alignment: .center)
        
        rankButton.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.rank, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleAspectFit)
        
        winRateRankButton.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.winRateRank, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleAspectFit)
        
        historyButton.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.history, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleAspectFit)
        
        rulesButton.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.rules, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleAspectFit)
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(rankButton)
        stackView.addArrangedSubview(winRateRankButton)
        stackView.addArrangedSubview(spacerView)
        stackView.addArrangedSubview(historyButton)
        stackView.addArrangedSubview(rulesButton)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [rankButton, winRateRankButton, historyButton, rulesButton].forEach {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(30)
            }
        }
    }
 
    private func setupBindings() {
        disposeBag.insert(
            setupRankButtonObserving(),
            setupWinRateButtonObserving(),
            setupHistoryButtonObserving(),
            setupRulesButtonObserving()
        )
    }
    
    private func setupRankButtonObserving() -> Disposable {
        rankButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.rankSubject.onNext(())
            })
    }
    
    private func setupWinRateButtonObserving() -> Disposable {
        winRateRankButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.winRateSubject.onNext(())
            })
    }
    
    private func setupHistoryButtonObserving() -> Disposable {
        historyButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.historySubject.onNext(())
            })
    }
    
    private func setupRulesButtonObserving() -> Disposable {
        rulesButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.rulesSubject.onNext(())
            })
    }
    
    func setButtonsBackgroundColor(color: UIColor) {
        [rankButton, historyButton, rulesButton, winRateRankButton].forEach {
            $0.backgroundColor = color
        }
    }
    
}
