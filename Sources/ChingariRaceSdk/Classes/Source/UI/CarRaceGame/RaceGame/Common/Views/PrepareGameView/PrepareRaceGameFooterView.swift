//
//  PrepareRaceGameFooterView.swift
//  chingari
//
//  Created by Sergey Pritula on 18.08.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PrepareRaceGameFooterView: CHView {
    
    private let containerView = UIView()
    
    private let stackView = UIStackView()
    
    private let diamondStackView = UIStackView()
    
    private let minusButton = UIButton()
    
    private let plusButton = UIButton()
    
    private let backgroundImageView = UIImageView()
    
    private let diamondLabelContainer = UIView()
    
    private let diamondLabel = UILabel()
    
    private let diamondsIcon = UIImageView()
    
    private let playButton = UIButton()
    
    private var timer: Timer?
    private var minusTimer: Timer?
    
    private var holdDuration = 500 //FirebaseRemoteConfig.raceHoldStepValue
    private var holdScaleFactor = 20 //FirebaseRemoteConfig.raceHoldBetScaleFactorValue
    
    // INPUT
    let isEnabledSubject: PublishSubject<Bool> = .init()
    let betConfigRelay: BehaviorRelay<ChingariRaceSessionConfigurationBets?> = .init(value: nil)
    let currentBetRelay: BehaviorRelay<Int?> = .init(value: nil)
    let ownDiamondsRelay: BehaviorRelay<Int> = .init(value: 0)
    
    // OUTPUT
    private let betChangedSubject: PublishSubject<Int> = .init()
    var betChangedEvent: RxObservable<Int> { betChangedSubject }
    
    private let playSubject: PublishSubject<Void> = .init()
    var playEvent: RxObservable<Void> { playSubject }
    
    private var disposeBag = DisposeBag()
    
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
    
    override func setupView() {
        stackView.customizer
            .set(distribution: .fill)
            .set(axis: .horizontal)
            .set(alignment: .fill)
            .set(spacing: 10)
        
        diamondStackView.customizer
            .set(distribution: .fill)
            .set(axis: .horizontal)
            .set(alignment: .center)
        
        backgroundImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.diamondsInactive, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleToFill)
        
        diamondsIcon.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.diamond, in: .module, compatibleWith: nil))
            .set(isHidden: true)
        
        diamondLabel.customizer
            .set(font: .init(font: .poppinsBold, style: .callout))
            .set(textColor: .white)
        
        playButton.customizer
            .set(backgroundImage: UIImage(named: CarRaceGameConstants.Images.playBackgroundInactive, in: .module, compatibleWith: nil))
            .set(font: .init(font: .poppinsRegular, style: .title3))
        
        minusButton.setImage(UIImage(named: CarRaceGameConstants.Images.minus, in: .module, compatibleWith: nil), for: .normal)
        plusButton.setImage(UIImage(named: CarRaceGameConstants.Images.plus, in: .module, compatibleWith: nil), for: .normal)
        
        plusButton.addTarget(self, action: #selector(buttonDown), for: .touchDown)
        plusButton.addTarget(self, action: #selector(buttonDown), for: .touchDragExit)
        plusButton.addTarget(self, action: #selector(buttonUp), for: [.touchUpInside, .touchUpOutside])
        
        minusButton.addTarget(self, action: #selector(minusButtonDown), for: .touchDown)
        minusButton.addTarget(self, action: #selector(minusButtonDown), for: .touchDragExit)
        minusButton.addTarget(self, action: #selector(minusButtonUp), for: [.touchUpInside, .touchUpOutside])
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubviews([backgroundImageView, stackView])
        
        stackView.addArrangedSubview(diamondStackView)
        stackView.addArrangedSubview(playButton)
        
        diamondStackView.addArrangedSubview(minusButton)
        diamondStackView.addArrangedSubview(diamondLabelContainer)
        diamondStackView.addArrangedSubview(plusButton)
        
        diamondLabelContainer.addSubview(diamondLabel)
        diamondLabelContainer.addSubview(diamondsIcon)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalTo(diamondStackView)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        playButton.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.33)
        }
        
        [minusButton, plusButton].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(26)
            }
        }
        
        diamondLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        diamondsIcon.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.leading.equalTo(diamondLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(diamondLabel)
        }
    }
    
    private func setupBindings() {
        disposeBag.insert([
            setupEnabledObserving(with: isEnabledSubject),
            setupCurrentBetRelayObserving(),
            setupPlayButtonObserving()
        ])
    }
    
    private func setupEnabledObserving(with signal: RxObservable<Bool>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (self, isEnabled) in
                self.playButton.isUserInteractionEnabled = isEnabled
                self.plusButton.isUserInteractionEnabled = isEnabled
                self.minusButton.isUserInteractionEnabled = isEnabled
                
                self.playButton.setBackgroundImage(UIImage(named: isEnabled ? CarRaceGameConstants.Images.playBackgroundActive : CarRaceGameConstants.Images.playBackgroundInactive, in: .module, compatibleWith: nil), for: .normal)
                
                self.backgroundImageView.image = UIImage(named: isEnabled ? CarRaceGameConstants.Images.diamondsActive : CarRaceGameConstants.Images.diamondsInactive, in: .module, compatibleWith: nil)
                
                self.diamondLabel.isHidden = !isEnabled
                self.diamondsIcon.isHidden = !isEnabled
            })
    }
    
    func sessionUpdated(with session: ChingariRaceSession) {
        if let duration = session.configuration.bets.holdStep {
            self.holdDuration = duration
        }
        
        if let scaleFactor = session.configuration.bets.holdScaleFactor {
            self.holdScaleFactor = scaleFactor
        }
    }
    
    @objc func minusButtonDown(_ sender: UIButton) {
        print("\(#function)")
        minusButtonClicked()
       
        let interval = Double(self.holdDuration) / 1000.0
        self.minusTimer = Timer.scheduledTimer(
            timeInterval: TimeInterval(interval),
            target: self,
            selector: #selector(minusButtonHold),
            userInfo: nil,
            repeats: true
        )
    }

    @objc func minusButtonUp(_ sender: UIButton) {
        print("\(#function)")
        minusTimer?.invalidate()
        minusTimer = nil
    }
    
    @objc func buttonDown(_ sender: UIButton) {
        print("\(#function)")
        plusButtonClicked()
        
        let interval = Double(self.holdDuration) / 1000.0
        self.timer = Timer.scheduledTimer(
            timeInterval: TimeInterval(interval),
            target: self,
            selector: #selector(plusButtonHold),
            userInfo: nil,
            repeats: true
        )
    }

    @objc func buttonUp(_ sender: UIButton) {
        print("\(#function)")
        timer?.invalidate()
        timer = nil
    }

    func minusButtonClicked() {
        print("\(#function)")
        
        let currentBet = self.currentBetRelay.value ?? 0
        let step = betConfigRelay.value?.step ?? 0
        let min = betConfigRelay.value?.min ?? 0
        let newBet = currentBet - step
        
        if newBet >= min {
            self.betChangedSubject.onNext(newBet)
        } else {
            self.betChangedSubject.onNext(min)
        }
    }

    @objc func minusButtonHold() {
        print("\(#function)")
        
        if !minusButton.isHighlighted {
            minusTimer?.invalidate()
            minusTimer = nil
            return
        }
        
        let currentBet = self.currentBetRelay.value ?? 0
        let step = (betConfigRelay.value?.step ?? 0) * self.holdScaleFactor
        let newBet = currentBet - step
        let min = betConfigRelay.value?.min ?? 0
        
        if newBet >= min {
            self.betChangedSubject.onNext(newBet)
        } else {
            self.betChangedSubject.onNext(min)
        }
    }
    
    func plusButtonClicked() {
        print("\(#function)")
        
        let currentBet = self.currentBetRelay.value ?? 0
        let step = betConfigRelay.value?.step ?? 0
        let newBet = currentBet + step
        
        if newBet > ownDiamondsRelay.value {
            let min = self.betConfigRelay.value?.min ?? 0
            if ownDiamondsRelay.value < min {
                return
            }
            
            self.betChangedSubject.onNext(ownDiamondsRelay.value)
            return
        }
        
        self.betChangedSubject.onNext(newBet)
    }

    @objc func plusButtonHold() {
        print("\(#function)")
        
        if !plusButton.isHighlighted {
            timer?.invalidate()
            timer = nil
            return
        }
        
        let currentBet = self.currentBetRelay.value ?? 0
        let step = (betConfigRelay.value?.step ?? 0) * self.holdScaleFactor
        let newBet = currentBet + step
        
        if newBet > ownDiamondsRelay.value {
            let min = self.betConfigRelay.value?.min ?? 0
            if ownDiamondsRelay.value < min {
                return
            }
            
            self.betChangedSubject.onNext(ownDiamondsRelay.value)
            return
        }
        
        self.betChangedSubject.onNext(newBet)
    }
    
    private func setupCurrentBetRelayObserving() -> Disposable {
        currentBetRelay
            .subscribe(onNext: { [weak self] bet in
                self?.diamondLabel.text = "\(bet ?? 0)"
            })
    }
    
    private func setupPlayButtonObserving() -> Disposable {
        playButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.playSubject.onNext(())
            })
    }
}
