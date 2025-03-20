//
//  WinRateViewModel.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WinRateViewModel: DeinitAnnouncerType {
    
    private let networkService: ChingariRaceNetworkServiceProtocol
    
    private let itemsRelay = BehaviorRelay<[WinRateRankCellViewModel]>(value: [])
    
    private let loadingRelay = BehaviorRelay<Bool>(value: false)
    
    private(set) var detailsSubject = PublishSubject<(index: Int, cars: [Car])>()
    
    private(set) var dissmissPublisher = PublishSubject<Void>()
    
    struct Injections {
        let networkService: ChingariRaceNetworkServiceProtocol
    }
    
    init(injections: Injections) {
        self.networkService = injections.networkService
        setupDeinitAnnouncer()
    }
    
}

extension WinRateViewModel: ViewModelProtocol {
    
    struct Input {
        let backEvent: RxObservable<Void>
        let didSelect: Observable<WinRateRankCellViewModel>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let items: RxObservable<[WinRateRankCellViewModel]>
        let loading: RxObservable<Bool>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupDidSelectObserving(with: input.didSelect),
            setupFetchCardObserving(),
            setupBackButtonObserving(with: input.backEvent)
        ])
        
        let output = Output(
            items: itemsRelay.asObservable(),
            loading: loadingRelay.asObservable()
        )
        
        outputHandler(output)
    }
        
    private func setupDidSelectObserving(with signal: RxObservable<WinRateRankCellViewModel>) -> Disposable {
        signal.subscribe(onNext: { [weak self] selectedModel in
            guard let index = self?.itemsRelay.value.firstIndex(where: { $0.model.id == selectedModel.model.id }) else { return }
            
            let cars: [Car] = self?.itemsRelay.value.map { $0.model } ?? []
            self?.detailsSubject.onNext((index, cars))
        })
    }
    
    private func setupFetchCardObserving() -> Disposable {
        loadingRelay.accept(true)
        
        return networkService.cars(requestData: .init())
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (self, response) in
                let items = response.data.map { WinRateRankCellViewModel(model: $0) }
                self.itemsRelay.accept(items)
                self.loadingRelay.accept(false)
            })
    }
    
    private func setupBackButtonObserving(with signal: RxObservable<Void>) -> Disposable {
        signal
            .subscribe(onNext: { [weak self] in
                self?.dissmissPublisher.onNext(())
            })
    }
}
