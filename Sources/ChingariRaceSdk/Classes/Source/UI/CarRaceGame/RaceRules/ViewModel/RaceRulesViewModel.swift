//
//  RaceRulesViewModel.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RaceRulesViewModel: DeinitAnnouncerType {
    
    struct Injections {
        let networkService: ChingariRaceNetworkServiceProtocol
    }
    
    private let networkService: ChingariRaceNetworkServiceProtocol
    
    private let injections: Injections
    
    private let rulesSubject = PublishRelay<String>()
    
    var dissmissPublisher = PublishSubject<Void>()
    
    init(injections: Injections) {
        self.injections = injections
        self.networkService = injections.networkService
        
        setupDeinitAnnouncer()
    }
    
}

// MARK: - ViewModelProtocol

extension RaceRulesViewModel: ViewModelProtocol {
    
    struct Input {
        let backEvent: RxObservable<Void>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let message: Driver<String>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert(
            setupFetchRulesObserving(),
            setupBackButtonObserving(with: input.backEvent)
        )
        
        let output = Output(
            message: rulesSubject.asDriver(onErrorJustReturn: "")
        )
        outputHandler(output)
    }
    
    private func setupFetchRulesObserving() -> Disposable {
        networkService.rule(requestData: .init())
            .asObservable()
            .subscribe(onNext: { response in
                
            })
    }
    
    private func setupBackButtonObserving(with signal: RxObservable<Void>) -> Disposable {
        signal
            .subscribe(onNext: { [weak self] in
                self?.dissmissPublisher.onNext(())
            })
    }
    
}
