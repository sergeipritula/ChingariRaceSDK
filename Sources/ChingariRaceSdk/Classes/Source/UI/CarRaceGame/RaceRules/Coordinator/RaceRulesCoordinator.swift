//
//  RaceRulesCoordinator.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

internal final class RaceRulesCoordinator: CHBaseCoordinator<Void> {
    
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
        let injections = RaceRulesViewModel.Injections(
            networkService: injections.networkService
        )
        let viewModel = RaceRulesViewModel(injections: injections)
        let view = RaceRulesViewController(viewModel: viewModel)
        view.modalTransitionStyle = .crossDissolve
        view.modalPresentationStyle = .overFullScreen
        self.injections.presentedController.presentPanModal(view)
        
        let backEvent = viewModel.dissmissPublisher
            .do(onNext: { [weak view] in
                view?.dismiss(animated: true)
            })
        
        return Observable.merge(backEvent, view.dismissPublisher)
    }
  
}
