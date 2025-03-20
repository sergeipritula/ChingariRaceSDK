//
//  SpeedRankCoordinator.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

internal final class SpeedRankCoordinator: CHBaseCoordinator<Void> {
    
    struct Injections {
        let presentedController: UIViewController
        let networkService: ChingariRaceNetworkServiceProtocol
        let carBets: [CarBet]
        let road: Road
    }
    
    private let injections: Injections
    
    init(injections: Injections) {
        self.injections = injections
        super.init()
    }
    
    override func start() -> RxObservable<Void> {
        let injections = SpeedRankViewModel.Injections(
            networkService: injections.networkService,
            carBets: injections.carBets,
            road: injections.road
        )
        
        let viewModel = SpeedRankViewModel(injections: injections)
        let view = SpeedRankViewController(viewModel: viewModel)
        
        view.modalTransitionStyle = .crossDissolve
        view.modalPresentationStyle = .overFullScreen
        self.injections.presentedController.presentPanModal(view)
        
        let backEvent = viewModel.dismissPublisher
            .do(onNext: { [weak view] in
                view?.dismiss(animated: true)
            })
        
        return Observable.merge(backEvent, view.dismissPublisher)
    }
  
}
