//
//  RaceHistoryDetailsCoordinator.swift
//  chingari
//
//  Created by Sergey Pritula on 26.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

internal final class RaceHistoryDetailsCoordinator: CHBaseCoordinator<Void> {
    
    struct Injections {
        let presentedController: UIViewController
        let networkService: ChingariRaceNetworkServiceProtocol
        let sessionId: String
    }
    
    private let injections: Injections
    
    init(injections: Injections) {
        self.injections = injections
        super.init()
    }
    
    override func start() -> RxObservable<Void> {
        let injections = RaceHistoryDetailsViewModel.Injections(
            networkService: injections.networkService,
            sessionId: injections.sessionId
        )
        
        let viewModel = RaceHistoryDetailsViewModel(injections: injections)
        let view = RaceHistoryDetailsViewController(viewModel: viewModel)
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
