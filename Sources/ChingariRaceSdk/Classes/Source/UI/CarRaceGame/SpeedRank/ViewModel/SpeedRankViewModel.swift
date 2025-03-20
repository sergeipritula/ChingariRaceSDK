//
//  SpeedRankViewModel.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SpeedRankViewModel: DeinitAnnouncerType {
   
    private let networkService: ChingariRaceNetworkServiceProtocol
    
    private(set) var dismissPublisher = PublishSubject<Void>()
    
    private let itemsRelay = BehaviorRelay<[SpeedRankCellViewModel]>(value: [])
    
    private let roadSubject = PublishSubject<Road>()
    
    private let loadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let carBets: [CarBet]
    
    private let road: Road
    
    struct Injections {
        let networkService: ChingariRaceNetworkServiceProtocol
        let carBets: [CarBet]
        let road: Road
    }
    
    init(injections: Injections) {
        self.networkService = injections.networkService
        self.carBets = injections.carBets
        self.road = injections.road
        setupDeinitAnnouncer()
    }
    
}

// MARK: - ViewModelProtocol

extension SpeedRankViewModel: ViewModelProtocol {
    
    struct Input {
        let backEvent: RxObservable<Void>
        let itemSelected: Observable<SpeedRankCellViewModel>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let items: RxObservable<[SpeedRankCellViewModel]>
        let road: RxObservable<Road>
        let loading: Driver<Bool>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupFetchCardObserving(),
            setupBackButtonObserving(with: input.backEvent),
        ])
        
        let output = Output(
            items: itemsRelay.asObservable(),
            road: roadSubject.asObservable(),
            loading: loadingRelay.asDriver()
        )
        
        outputHandler(output)
        
        roadSubject.onNext(road)
    }
    
    private func setupFetchCardObserving() -> Disposable {
        loadingRelay.accept(true)
        
        return networkService.cars(requestData: .init())
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (self, response) in
                let items = response.data.enumerated().map { (index, car) in
                    let isHighlighted = self.carBets.contains(where: { $0.car.id == car.id })
                    
                    return SpeedRankCellViewModel(
                        index: index + 1,
                        model: car,
                        isHighlighted: isHighlighted,
                        road: self.road
                    )
                }
                
                self.itemsRelay.accept(items)
                self.loadingRelay.accept(false)
            })
    }
    
    private func setupBackButtonObserving(with signal: RxObservable<Void>) -> Disposable {
        signal
            .subscribe(onNext: { [weak self] in
                self?.dismissPublisher.onNext(())
            })
    }
    
    
}
