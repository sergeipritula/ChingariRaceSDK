//
//  WinRateRankCoordinator.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

internal final class WinRateRankCoordinator: CHBaseCoordinator<Void> {
    
    struct Injections {
        let presentedController: UIViewController
        let networkService: ChingariRaceNetworkServiceProtocol
    }
    
    private let injections: Injections
    
    init(injections: Injections) {
        self.injections = injections
        super.init()
    }
    
    override func start() -> RxObservable<Void> {
        let viewModel = WinRateViewModel(injections: .init(networkService: injections.networkService))
        let view = WinRateViewController(viewModel: viewModel)
        view.modalTransitionStyle = .crossDissolve
        view.modalPresentationStyle = .overFullScreen
        self.injections.presentedController.presentPanModal(view)
        
        viewModel.detailsSubject
            .subscribe(onNext: { [weak self] in
                self?.showDetails(index: $0.0, models: $0.1)
            })
            .disposed(by: view.disposeBag)
        
        let backEvent = viewModel.dissmissPublisher
            .do(onNext: { [weak view] in
                view?.dismiss(animated: true)
            })
        
        return Observable.merge(backEvent, view.dismissPublisher)
    }
  
}

extension WinRateRankCoordinator {
    func showDetails(index: Int, models: [Car]) {
        guard let controller = injections.presentedController.presentedViewController else { return }
        
        let coordinator = RankDetailsCoordinator(injections: .init(presentedController: controller,
                                                                   cars: models,
                                                                   index: index))
        
        coordinator.start()
            .subscribe()
            .disposed(by: disposeBag)
    }
    
}
