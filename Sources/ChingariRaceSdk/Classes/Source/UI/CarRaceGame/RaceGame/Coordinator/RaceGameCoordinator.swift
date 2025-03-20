//
//  RaceGameCoordinator.swift
//  chingari
//
//  Created by Sergey Pritula on 24.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

enum RaceGameCoordinatorEvent {
    case dismiss
    case rate(carBets: [CarBet], road: Road)
    case winRate
    case history
    case historyDetails(sessionId: String)
    case rules
    case diamondsPurchase
    case insufficientDiamondsPopup
    case leaderboard
}

final class RaceGameCoordinator: CHBaseCoordinator<Void> {
    
    struct Injections {
//        let targetProvider: MainCoordinator
        let presentedController: UIViewController
        let service: ChingariRaceServiceProtocol
        let networkService: ChingariRaceNetworkServiceProtocol
        let session: ChingariRaceSession
//        let diamondsUseCase: PlansUseCaseProtocol
    }
    
    private let injections: Injections
    
    private var speedRankCoordinator: SpeedRankCoordinator?
    private var winRateCoordinator: WinRateRankCoordinator?
    private var historyCoordinator: RaceHistoryCoordinator?
    private var historyDetailsCoordinator: RaceHistoryDetailsCoordinator?
    private var rulesCoordinator: RaceRulesCoordinator?
//    private var diamondsCoordinator: BuyDiamondsPlanCoordinator?
//    private var webCoordinator: CHWebViewCoordinatorPresent?
//    private var profileCoordinator: ProfileCoordinator?
    private var navigationController: UINavigationController?
    
    init(injections: Injections) {
        self.injections = injections
        super.init()
    }
    
    override func start() -> RxObservable<Void> {
        let vmInjections = RaceGameViewModel.Injections(
            service: injections.service,
            networkService: injections.networkService,
            session: injections.session
//            diamondsUseCase: injections.diamondsUseCase
        )
        
        let viewModel = RaceGameViewModel(injections: vmInjections)
        let view = RaceGameViewController(viewModel: viewModel)
        
        view.modalTransitionStyle = .crossDissolve
        view.modalPresentationStyle = .overFullScreen
        
        self.injections.presentedController.presentPanModal(view)
        
        viewModel.redirectEventPublisher.asObservable()
            .subscribe(onNext: { [weak self] event in
                self?.handleEvent(event, viewModel: viewModel)
            })
            .disposed(by: disposeBag)
        
        return viewModel.redirectEventPublisher
            .asObservable()
            .filter {
                switch $0 {
                case .dismiss: return true
                default: return false
                }
            }
            .mapToVoid()
            .do(onNext: {
                view.dismiss(animated: true)
            })
    }
  
}

extension RaceGameCoordinator {
    
    func handleEvent(_ event: RaceGameCoordinatorEvent, viewModel: RaceGameViewModel) {
        switch event {
        case .dismiss:
            break
        case .rate(let carBets, let road):
            showRate(carBets: carBets, road: road)
        case .winRate:
            showWinRank()
        case .history:
            showHistory()
        case .historyDetails:
            showHistory()
        case .rules:
            showRules()
        case .insufficientDiamondsPopup:
            showInsufficientDiamondsPopup(fetchDiamondsPublisher: viewModel.fetchDiamondsSubject)
        case .diamondsPurchase:
            showDiamondsPurchase(fetchDiamondsPublisher: viewModel.fetchDiamondsSubject)
        case .leaderboard: 
            coordinateToWebView()
        }
    }
    
    private func showRate(carBets: [CarBet], road: Road) {
        guard let controller = injections.presentedController.presentedViewController else { return }
        
        let injections = SpeedRankCoordinator.Injections(
            presentedController: controller,
            networkService: injections.networkService,
            carBets: carBets,
            road: road
        )
        
        speedRankCoordinator = SpeedRankCoordinator(injections: injections)
        speedRankCoordinator?.start()
            .subscribe(onNext: { [weak self] in
                self?.speedRankCoordinator = nil
            })
            .disposed(by: disposeBag)
    }
    
    private func showWinRank() {
        guard let controller = injections.presentedController.presentedViewController else { return }
        
        let injections = WinRateRankCoordinator.Injections(
            presentedController: controller,
            networkService: injections.networkService
        )
        
        winRateCoordinator = WinRateRankCoordinator(injections: injections)
        winRateCoordinator?.start()
            .subscribe(onNext: { [weak self] in
                self?.winRateCoordinator = nil
            })
            .disposed(by: disposeBag)
    }
    
    private func showHistory() {
        guard let controller = injections.presentedController.presentedViewController else { return }
        
        let injections = RaceHistoryCoordinator.Injections(
            presentedController: controller,
            networkService: injections.networkService
        )
        historyCoordinator = RaceHistoryCoordinator(injections: injections)
        historyCoordinator?.start()
            .subscribe(onNext: { [weak self] in
                self?.historyCoordinator = nil
            })
            .disposed(by: disposeBag)
    }
    
    private func showHistoryDetails(sessionId: String) {
        guard let controller = injections.presentedController.presentedViewController else { return }
        
        let injections = RaceHistoryDetailsCoordinator.Injections(
            presentedController: controller,
            networkService: injections.networkService,
            sessionId: sessionId
        )
        historyDetailsCoordinator = RaceHistoryDetailsCoordinator(injections: injections)
        historyDetailsCoordinator?.start()
            .subscribe(onNext: { [weak self] in
                self?.historyCoordinator = nil
            })
            .disposed(by: disposeBag)
    }
    
    private func showRules() {
        guard let controller = injections.presentedController.presentedViewController else { return }
        
        let injections = RaceRulesCoordinator.Injections(
            presentedController: controller,
            networkService: injections.networkService
        )
        rulesCoordinator = RaceRulesCoordinator(injections: injections)
        rulesCoordinator?.start()
            .subscribe(onNext: { [weak self] in
                self?.rulesCoordinator = nil
            })
            .disposed(by: disposeBag)
    }
    private func showDiamondsPurchase(fetchDiamondsPublisher: PublishSubject<Void>) {
        GameCenter.shared.delegate?.openDiamondStore()
    }
    
    private func showInsufficientDiamondsPopup(fetchDiamondsPublisher: PublishSubject<Void>) {
        
    }
    
    func coordinateToWebView() {
        GameCenter.shared.delegate?.openLeaderboard()
    }
}
