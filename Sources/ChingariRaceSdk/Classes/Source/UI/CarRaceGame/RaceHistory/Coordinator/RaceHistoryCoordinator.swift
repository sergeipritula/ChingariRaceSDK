//
//  RaceHistoryCoordinator.swift
//  chingari
//
//  Created by Sergey Pritula on 26.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

internal final class RaceHistoryCoordinator: CHBaseCoordinator<Void> {
    
    struct Injections {
        let presentedController: UIViewController
        let networkService: ChingariRaceNetworkServiceProtocol
    }
    
    private let injections: Injections
    
    private var detailsCoordinator: RaceHistoryDetailsCoordinator?
    
    init(injections: Injections) {
        self.injections = injections
        super.init()
    }
    
    override func start() -> RxObservable<Void> {
        let viewModel = RaceHistoryViewModel(injections: .init(networkService: injections.networkService))
        let view = RaceHistoryViewController(viewModel: viewModel)
        view.modalTransitionStyle = .crossDissolve
        view.modalPresentationStyle = .overFullScreen
        self.injections.presentedController.presentPanModal(view)
        
        viewModel.redirectToDetailsPublisher
            .withUnretained(self)
            .subscribe(onNext: { (self, sessionId) in
                self.showDetails(sessionId: sessionId)
            })
            .disposed(by: disposeBag)
        
        let backEvent = viewModel.dissmissPublisher
            .do(onNext: { [weak view] in
                view?.dismiss(animated: true)
            })
        
        return Observable.merge(backEvent, view.dismissPublisher)
    }
  
}

internal extension RaceHistoryCoordinator {
    func showDetails(sessionId: String) {
        guard let controller = self.injections.presentedController.presentedViewController else { return }
        
        detailsCoordinator = RaceHistoryDetailsCoordinator(injections: .init(
            presentedController: controller,
            networkService: self.injections.networkService,
            sessionId: sessionId))
        
        detailsCoordinator?.start()
            .subscribe(onNext: { [weak self] in
                self?.detailsCoordinator = nil
            })
            .disposed(by: disposeBag)
    }
}
