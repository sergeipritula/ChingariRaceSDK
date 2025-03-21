//
//  RaceGameViewController.swift
//  chingari
//
//  Created by Sergey Pritula on 24.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

class RaceGameViewController: ViewController<RaceGameViewModel> {
    
    private(set) var dismissPublisher = PublishSubject<Void>()
    
    private let dismissView = UIView()
    
    private let containerView = UIView()
    
    private let backgroundImageView = UIImageView()
    
    private let blurBacgroundImage = UIImageView()
    
    private let logoImageView = UIImageView()
    
    private let actionsHeaderView = GameActionsHeaderView()
    
    private let prepareRaceGameView = PrepareRaceGameView()
    
    private let raceGameView = RaceGameView()
    
    private let diamondConfirmView = DiamondsConfirmView()
    
    private let raceResultView = RaceResultView()
    
    override func setupView() {
        view.backgroundColor = .clear
        containerView.backgroundColor = .clear
        
        backgroundImageView.customizer
            .set(clipsToBounds: false)
            .set(image: UIImage(named: CarRaceGameConstants.Images.raceBackground, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleToFill)
        
        blurBacgroundImage.customizer
            .set(clipsToBounds: false)
            .set(image: UIImage(named: CarRaceGameConstants.Images.raceBackgroundBlur, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleToFill)
        
        logoImageView.customizer.set(contentMode: .scaleAspectFit)
        
        raceGameView.isHidden = true
        diamondConfirmView.isHidden = true
        logoImageView.isHidden = true
        
        blurBacgroundImage.isHidden = true
        blurBacgroundImage.isUserInteractionEnabled = true
        
        if let backgroundColor = GameCenter.shared.gameTheme.buttonBackgroundColor {
            actionsHeaderView.setButtonsBackgroundColor(color: backgroundColor)
        }
        
        if let logo = GameCenter.shared.gameTheme.logo {
            logoImageView.image = UIImage(named: logo)
            logoImageView.isHidden = false
        }
    }
    
    override func setupConstraints() {
        view.addSubview(dismissView)
        view.addSubview(containerView)
        view.addSubview(actionsHeaderView)
        
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(prepareRaceGameView)
        containerView.addSubview(raceGameView)
        
        containerView.addSubview(blurBacgroundImage)
        containerView.addSubview(diamondConfirmView)
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(420)
        }
        
        dismissView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(containerView.snp.top)
        }
        
        actionsHeaderView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        blurBacgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.centerY.equalTo(actionsHeaderView).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.35)
            $0.height.equalTo(40)
        }
        
        prepareRaceGameView.snp.makeConstraints { [unowned self] in
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(logoImageView.snp.bottom).offset(22)
            $0.bottom.equalToSafe(of: self)
        }
        
        raceGameView.snp.makeConstraints { [unowned self] in
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(logoImageView.snp.bottom).offset(2)
            $0.bottom.equalToSafe(of: self)
        }
        
        diamondConfirmView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    override func setupInput(input: RaceGameViewModel.Output) {
        disposeBag.insert([
            setupRaceStateObserving(with: input.sessionEvent),
            setupCarBetsObserving(with: input.carBetsEvent),
            setupFooterEnabledObserving(with: input.isFooterEnabledEvent),
            setupBetConfigObserving(with: input.betConfigEvent),
            setupCurrentBetObserving(with: input.selectedCarBetValue),
            setupCurrentBetConfirmPopupObserving(with: input.selectedCarBetValue),
            setupPlayButtonObserving(with: input.betConfirmEvent),
            setupDiamondsConfirmObserving(),
            setupDiamondsConfirmCloseObserving(),
            setupOwnDiamondsObserving(with: input.ownDiamondsEvent),
            setupPlacedBetsItemsObserving(with: input.carBetsEvent.asObservable()),
            setupTimeLeftObserving(with: input.timeLeftEvent)
        ])
    }
    
    override func setupOutput() {
        let dismissEvent = Observable.merge(
//            dismissView.rx.tapGesture().when(.recognized).mapToVoid(),
            dismissPublisher.asObservable()
        )
        
        let input = RaceGameViewModel.Input(
            leaderBoardEvent: actionsHeaderView.rankObservable,
            rankEvent: prepareRaceGameView.roadsView.roadClickEvent,
            winRateEvent: actionsHeaderView.winRateObservable,
            historyEvent: actionsHeaderView.historyObservable,
            historyDetailsEvent: raceGameView.raceInfoEvent,
            rulesEvent: actionsHeaderView.rulesObservable,
            dismissEvent: dismissEvent,
            selectedBetEvent: prepareRaceGameView.selectEvent,
            currentBetEvent: prepareRaceGameView.footer.betChangedEvent.asObservable(),
            placeBetEvent: diamondConfirmView.confirmEvent, 
            buyDiamonds: prepareRaceGameView.header.addDiamondsEvent,
            playEvent: prepareRaceGameView.footer.playEvent,
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
    
    private func setupRaceStateObserving(with signal: Driver<ChingariRaceSession>) -> Disposable {
        signal.drive(onNext: { [weak self] session in
            guard let self = self else { return }
            
            self.prepareRaceGameView.sessionSubject.onNext(session)
            self.raceGameView.sessionSubject.onNext(session)
            
            switch session.state {
            case .bet:
                self.prepareRaceGameView.isHidden = false
                self.raceGameView.isHidden = true
                break
            case .gameInProgress, .processingBets, .result, .startInProgess:
                self.prepareRaceGameView.isHidden = true
                self.raceGameView.isHidden = false
                self.diamondConfirmView.isHidden = true
                self.blurBacgroundImage.isHidden = true
                break
            }            
        })
    }
    
    private func setupCarBetsObserving(with signal: BehaviorRelay<[BetCarCellViewModel]>) -> Disposable {
        signal.bind(to: self.prepareRaceGameView.itemsRelay)
    }
    
    private func setupFooterEnabledObserving(with signal: RxObservable<Bool>) -> Disposable {
        signal.bind(to: prepareRaceGameView.footer.isEnabledSubject)
    }
    
    private func setupBetConfigObserving(
        with signal: RxObservable<ChingariRaceSessionConfigurationBets>
    ) -> Disposable {
        signal.bind(to: prepareRaceGameView.footer.betConfigRelay)
    }
    
    private func setupCurrentBetObserving(with signal: RxObservable<Int>) -> Disposable {
        signal.bind(to: prepareRaceGameView.footer.currentBetRelay)
    }
    
    private func setupCurrentBetConfirmPopupObserving(with signal: RxObservable<Int>) -> Disposable {
        signal.bind(to: diamondConfirmView.currentBetRelay)
    }
    
    private func setupPlayButtonObserving(with signal: RxObservable<Void>) -> Disposable {
        signal
            .subscribe(onNext: { [weak self] in
                self?.diamondConfirmView.isHidden = false
                self?.blurBacgroundImage.isHidden = false
            })
    }
    
    private func setupDiamondsConfirmCloseObserving() -> Disposable {
        diamondConfirmView.closeEvent
            .subscribe(onNext: { [weak self] in
                self?.diamondConfirmView.isHidden = true
                self?.blurBacgroundImage.isHidden = true
            })
    }
    
    private func setupDiamondsConfirmObserving() -> Disposable {
        diamondConfirmView.confirmEvent
            .subscribe(onNext: { [weak self] in
                self?.diamondConfirmView.isHidden = true
                self?.blurBacgroundImage.isHidden = true
            })
    }
    
    private func setupOwnDiamondsObserving(with signal: RxObservable<Int>) -> Disposable {
        signal
            .subscribe(onNext: { [weak self] in
                self?.prepareRaceGameView.header.ownDiamondsRelay.accept($0)
                self?.prepareRaceGameView.footer.ownDiamondsRelay.accept($0)
            })
    }
    
    private func setupPlacedBetsItemsObserving(with signal: RxObservable<[BetCarCellViewModel]>) -> Disposable {
        signal.bind(to: raceGameView.itemsRelay)
    }
    
    private func setupTimeLeftObserving(with signal: RxObservable<Int>) -> Disposable {
        signal.bind(to: prepareRaceGameView.header.timeLeftSubject)
    }
    
}

//MARK: - PanModalPresentable

extension RaceGameViewController: PanModalPresentable {
    var longFormHeight: PanModalHeight {
        return .contentHeight(470)
    }
    
    var panModalBackgroundColor: UIColor {
        .clear
    }
    
    var showDragIndicator: Bool { false }
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    func panModalDidDismiss() {
        dismissPublisher.onNext(())
    }
}
