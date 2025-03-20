//
//  RaceGameViewModel.swift
//  chingari
//
//  Created by Sergey Pritula on 24.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum RaceGameSourceType: String {
    case liveRoom = "live-room"
    case liveRoomPkBattle = "live-room-pk-battle"
    case audioRoom = "audio-room"
    case privateCall = "private-call"
    case chat
    case feed
    case paidDm = "paid_dm"
    case gameRoom = "game_room"
}

class RaceGameViewModel: DeinitAnnouncerType {
    
    private(set) var redirectEventPublisher = PublishSubject<RaceGameCoordinatorEvent>()
    
//    private let alertService = AlertViewService()
    
    private let service: ChingariRaceServiceProtocol
    
    private let networkService: ChingariRaceNetworkServiceProtocol
    
//    private let diamondsUseCase: PlansUseCaseProtocol
    
    private var session: ChingariRaceSession
    
    private let raceSessionUpdatedPublisher = PublishSubject<ChingariRaceSession>()
    
    private let carBetsRelay = BehaviorRelay<[BetCarCellViewModel]>(value: [])
    
    private let currentBetRelay = BehaviorRelay<Int>(value: 0)
    
    private let footerEnabledRelay = BehaviorRelay<Bool>(value: false)
    
    private let betConfigSubject = PublishSubject<ChingariRaceSessionConfigurationBets>()
    
    private let ownDiamondsRelay = BehaviorRelay<Int>(value: 0)
    
    private let showBetConfirmPopupPublisher = PublishSubject<Void>()
    
    private let timeLeftSubject = PublishSubject<Int>()
    
    let fetchDiamondsSubject = PublishSubject<Void>()
    
    private var timer: Timer?
    private var timeLeft: Int = 0
    
    private let disposeBag = DisposeBag()
    
    struct Injections {
        let service: ChingariRaceServiceProtocol
        let networkService: ChingariRaceNetworkServiceProtocol
        let session: ChingariRaceSession
//        let diamondsUseCase: PlansUseCaseProtocol
    }
    
    init(injections: Injections) {
        self.service = injections.service
        self.networkService = injections.networkService
        self.session = injections.session
//        self.diamondsUseCase = injections.diamondsUseCase
        
        service.subscribeOnSessionUpdate()
        setupDeinitAnnouncer()
    }
    
}

extension RaceGameViewModel: ViewModelProtocol {
    
    struct Input {
        let leaderBoardEvent: RxObservable<Void>
        let rankEvent: RxObservable<Road>
        let winRateEvent: RxObservable<Void>
        let historyEvent: RxObservable<Void>
        let historyDetailsEvent: RxObservable<Void>
        let rulesEvent: RxObservable<Void>
        let dismissEvent: RxObservable<Void>
        let selectedBetEvent: RxObservable<BetCarCellViewModel>
        let currentBetEvent: RxObservable<Int>
        let placeBetEvent: RxObservable<Void>
        let buyDiamonds: RxObservable<Void>
        let playEvent: RxObservable<Void>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let sessionEvent: Driver<ChingariRaceSession>
        let carBetsEvent: BehaviorRelay<[BetCarCellViewModel]>
        let isFooterEnabledEvent: RxObservable<Bool>
        let betConfigEvent: RxObservable<ChingariRaceSessionConfigurationBets>
        let selectedCarBetValue: RxObservable<Int>
        let ownDiamondsEvent: RxObservable<Int>
        let timeLeftEvent: RxObservable<Int>
        let betConfirmEvent: RxObservable<Void>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert(
            setupFetchDiamondsObserving(),
            setupSessionUpdatedObserving(),
            setupRankButtonObserving(with: input.rankEvent),
            setupWinRateButtonObserving(with: input.winRateEvent),
            setupHistoryButtonObserving(with: input.historyEvent),
            setupRulesButtonObserving(with: input.rulesEvent),
            setupDismissSignalObserving(with: input.dismissEvent),
            setupBetSelectionObserving(with: input.selectedBetEvent),
            setupCurrentBetObserving(with: input.currentBetEvent),
            setupPlaceBetObserving(with: input.placeBetEvent),
            setupRedirectToDiamondsPurchase(with: input.buyDiamonds),
            setupRedirectToLeaderboard(with: input.leaderBoardEvent),
            setupHistoryDetailsObserving(with: input.historyDetailsEvent),
            setupPlayButtonObserving(with: input.playEvent)
            
        )
        
        let output = Output(
            sessionEvent: raceSessionUpdatedPublisher.asDriverOnErrorJustComplete(),
            carBetsEvent: carBetsRelay,
            isFooterEnabledEvent: footerEnabledRelay.asObservable(),
            betConfigEvent: betConfigSubject.asObservable(),
            selectedCarBetValue: currentBetRelay.asObservable(),
            ownDiamondsEvent: ownDiamondsRelay.asObservable(),
            timeLeftEvent: timeLeftSubject.asObservable(),
            betConfirmEvent: showBetConfirmPopupPublisher.asObservable()
        )
        
        outputHandler(output)
        
        let carBetsModels = session.carBets.map { BetCarCellViewModel(from: $0) }
        
        carBetsModels.forEach { carBet in
            let total = session.myBets?
                .filter { $0.carBetId == carBet.carBet.id }
                .reduce(0) { $0 + $1.betAmount } ?? 0
            
            carBet.placedBetRelay.accept(total)
            carBet.currentBetRelay.accept(total)
        }
        
        carBetsRelay.accept(carBetsModels)
        betConfigSubject.onNext(session.configuration.bets)
        currentBetRelay.accept(session.configuration.bets.min)
        
        raceSessionUpdatedPublisher.onNext(session)
        
        timeLeft = session.timeLeft / 1000
        timeLeftSubject.onNext(timeLeft)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeLeft <= 0 {
                self.timer?.invalidate()
            } else {
                self.timeLeft -= 1
                self.timeLeftSubject.onNext(self.timeLeft)
            }
        }
        
        fetchDiamondsSubject.onNext(())
    }
    
    private func setupSessionUpdatedObserving() -> Disposable {
        service.sessionUpdatedObservable
            .withUnretained(self)
            .subscribe(onNext: { (self, response) in
                let session = response.session
                self.session = session
                
                self.raceSessionUpdatedPublisher.onNext(session)
                
                let currentCarBets = self.carBetsRelay.value
                let newCarBets = session.carBets.map { BetCarCellViewModel(from: $0) }
                
                for newCarBet in newCarBets {
                    if let carBet = currentCarBets.first(where: { $0.carBet.id == newCarBet.carBet.id }) {
                        newCarBet.isSelectedRelay.accept(carBet.isSelectedRelay.value)
                        newCarBet.currentBetRelay.accept(carBet.currentBetRelay.value)
                        newCarBet.placedBetRelay.accept(carBet.placedBetRelay.value)
                    }
                }
                
                let isSelected = newCarBets.filter { $0.isSelectedRelay.value }.count > 0
                self.footerEnabledRelay.accept(isSelected)
                self.carBetsRelay.accept(newCarBets)
                self.betConfigSubject.onNext(session.configuration.bets)
                
                if session.state == .bet {
                    self.timer?.invalidate()
                    self.timer = nil
                    self.timeLeft = session.timeLeft / 1000
                    
                    self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                        guard let self = self else { return }
                        
                        if self.timeLeft <= 0 {
                            self.timer?.invalidate()
                        } else {
                            self.timeLeft -= 1
                            self.timeLeftSubject.onNext(self.timeLeft)
                        }
                    }
                }
                
                if session.state == .result {
                    let rewardData = session.rewardData ?? []
                    self.currentBetRelay.accept(session.configuration.bets.min)
                    self.fetchDiamondsSubject.onNext(())
                    
                    
                }
            })
    }
    
    private func setupBetSelectionObserving(with signal: RxObservable<BetCarCellViewModel>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (self, viewModel) in
                let isSelected = viewModel.isSelectedRelay.value
                viewModel.isSelectedRelay.accept(!isSelected)
                
                let bets = self.carBetsRelay.value
                let selectedCarBets = bets.filter { $0.isSelectedRelay.value }
                let unselectedCarBets = bets.filter { !$0.isSelectedRelay.value }
                let isBetSelected = selectedCarBets.count > 0
                
                let currentBet = self.currentBetRelay.value
                
                if isBetSelected {
                    let betPerItem = Int(currentBet / selectedCarBets.count)
                    selectedCarBets.forEach { $0.placedBetRelay.accept(betPerItem + $0.currentBetRelay.value) }
                    
                    let totalBet = betPerItem * selectedCarBets.count
                    self.currentBetRelay.accept(totalBet)
                } else {
                    self.currentBetRelay.accept(self.session.configuration.bets.min)
                }
                
                unselectedCarBets.forEach { $0.placedBetRelay.accept($0.currentBetRelay.value) }
                
                
                self.footerEnabledRelay.accept(isBetSelected)
            })
    }
    
    private func setupCurrentBetObserving(with signal: RxObservable<Int>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (self, bet) in
                let bets = self.carBetsRelay.value
                let selectedCarBets = bets.filter { $0.isSelectedRelay.value }
                let isBetSelected = selectedCarBets.count > 0
                
                if isBetSelected {
                    let betPerItem = Int(bet / selectedCarBets.count)
                    selectedCarBets.forEach { $0.placedBetRelay.accept(betPerItem + $0.currentBetRelay.value) }
                    
                    let totalBet = betPerItem * selectedCarBets.count
                    self.currentBetRelay.accept(totalBet)
                } else {
                    self.currentBetRelay.accept(self.session.configuration.bets.min)
                }
            })
    }
    
    private func setupPlaceBetObserving(with signal: RxObservable<Void>) -> Disposable {
        signal
            .withUnretained(self)
            .flatMap({ (self, _) -> RxObservable<FEBetBalanceModel> in
                let selectedBets = self.carBetsRelay.value.filter { $0.isSelectedRelay.value }
                let betPerItem = Int(self.currentBetRelay.value / selectedBets.count)
                
                let bets = selectedBets.map { FEBetModel(carBetId: $0.carBet.id, amount: betPerItem) }
                let data = FEBetsModel(bets: bets)
                return self.service.sendBets(bets: data).asObservable()
            })
            .withUnretained(self)
            .subscribe(onNext: { (self, response) in
                let selectedBets = self.carBetsRelay.value.filter { $0.isSelectedRelay.value }
                let betPerItem = Int(self.currentBetRelay.value / selectedBets.count)
                
                selectedBets.forEach {
                    let currentBet = $0.currentBetRelay.value
                    $0.currentBetRelay.accept(currentBet + betPerItem)
                }
                
                self.footerEnabledRelay.accept(false)
                self.carBetsRelay.value.forEach { $0.isSelectedRelay.accept(false) }
                self.currentBetRelay.accept(self.session.configuration.bets.min)
//                self.ownDiamondsRelay.accept(response.data.balance)
                
                let totalBets = betPerItem * selectedBets.count
                GameCenter.shared.setBalance(self.ownDiamondsRelay.value - totalBets)
            }) { [weak self] error in
                guard let self = self else { return }
               
                if let error = error as? RoomCustomError {
                    let message = error.message ?? "Something went wrong"
                    
                    if message.contains("Not Enough Diamonds Available") {
                        self.redirectEventPublisher.onNext(.insufficientDiamondsPopup)
                        
                    } else {
//                        self.alertService.show(kind: .errorAR(text: message, priority: .primary))
                        GameCenter.shared.setBalance(ownDiamondsRelay.value)
                    }
                    
                    GameCenter.shared.delegate?.didBetFailed()
                }
                
                GameCenter.shared.delegate?.didBetSuccess()
                self.disposeBag.insert(self.setupPlaceBetObserving(with: signal))
            }
    }
    
    private func setupPlayButtonObserving(with signal: RxObservable<Void>) -> Disposable {
        signal
            .filter { _ in self.timeLeft > 2 }
            .subscribe(onNext: { [weak self] in
                self?.showBetConfirmPopupPublisher.onNext(())
            })
    }
    
    private func setupRulesButtonObserving(with signal: RxObservable<Void>) -> Disposable {
        signal.subscribe(onNext: { [weak self] in
            self?.redirectEventPublisher.onNext(.rules)
        })
    }
    
    private func setupRankButtonObserving(with signal: RxObservable<Road>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (self, road) in
                self.redirectEventPublisher.onNext(.rate(carBets: self.session.carBets, road: road))
            })
    }
    
    private func setupHistoryButtonObserving(with signal: RxObservable<Void>) -> Disposable {
        signal.subscribe(onNext: { [weak self] in
            self?.redirectEventPublisher.onNext(.history)
        })
    }
    
    private func setupWinRateButtonObserving(with signal: RxObservable<Void>) -> Disposable {
        signal.subscribe(onNext: { [weak self] in
            self?.redirectEventPublisher.onNext(.winRate)
        })
    }
    
    private func setupDismissSignalObserving(with signal: RxObservable<Void>) -> Disposable {
        signal.subscribe(onNext: { [weak self] in
            self?.service.unsubscribeSessionUpdate()
            self?.redirectEventPublisher.onNext(.dismiss)
        })
    }
 
    private func setupRedirectToDiamondsPurchase(with signal: RxObservable<Void>) -> Disposable {
        signal.subscribe(onNext: { [weak self] in
            self?.redirectEventPublisher.onNext(.diamondsPurchase)
        })
    }
    
    private func setupRedirectToLeaderboard(with signal: RxObservable<Void>) -> Disposable {
        signal.subscribe(onNext: { [weak self] in
            self?.redirectEventPublisher.onNext(.leaderboard)
        })
    }
    
    private func setupFetchDiamondsObserving() -> Disposable {
        GameCenter.shared.diamondSubject.bind(to: ownDiamondsRelay)
    }
    
    private func setupRoadClickedObserving(with signal: RxObservable<Road>) -> Disposable {
        signal
            .withUnretained(self)
            .subscribe(onNext: { (self, road) in
                self.redirectEventPublisher.onNext(.rate(carBets: self.session.carBets, road: road))
            })
    }
    
    private func setupHistoryDetailsObserving(with signal: RxObservable<Void>) -> Disposable {
        signal.subscribe(onNext: { [weak self] in
            guard let id = self?.session.sessionId else { return }
            self?.redirectEventPublisher.onNext(.historyDetails(sessionId: id))
        })
    }
    
}
