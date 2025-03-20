//
//  RaceHistoryViewModel.swift
//  chingari
//
//  Created by Sergey Pritula on 26.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum HistoryRaceType {
    case my
    case all
}

class RaceHistoryViewModel: DeinitAnnouncerType {
    
    struct Injections {
        let networkService: ChingariRaceNetworkServiceProtocol
    }
    
    private let injections: Injections
    
    private let itemsRelay = BehaviorRelay<[RaceHistoryCellViewModel]>(value: [])
    
    private let loadingRelay = BehaviorRelay<Bool>(value: false)
    
    private let historyTypeSubject = BehaviorRelay<HistoryRaceType>(value: .all)
    
    private(set) var redirectToDetailsPublisher = PublishSubject<String>()
    
    private(set) var dissmissPublisher = PublishSubject<Void>()
    
    private let loadMyHistorySubject = PublishSubject<Void>()
    
    private let loadHistorySubject = PublishSubject<Void>()
    
    private var offset = 0
    private var step = 20
    
    init(injections: Injections) {
        self.injections = injections
        setupDeinitAnnouncer()
    }
    
}

// MARK: - ViewModelProtocol

extension RaceHistoryViewModel: ViewModelProtocol {
    
    struct Input {
        let backEvent: RxObservable<Void>
        let historyTypeEvent: RxObservable<HistoryRaceType>
        let modelSelected: RxObservable<RaceHistoryCellViewModel>
        let loadMoreEvent: RxObservable<Void>
        let refreshEvent: RxObservable<Void>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let itemsEvent: RxObservable<[RaceHistoryCellViewModel]>
        let loadingEvent: Driver<Bool>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert(
            setupHistorySelected(),
            setupMyHistorySelected(),
            setupHistoryTypeEventObserving(with: input.historyTypeEvent),
            setupBackButtonObserving(with: input.backEvent),
            setupModelSelectedObserving(with: input.modelSelected),
            setupLoadHistoryItems(),
            setupLoadMyHistoryItems(),
            setupLoadMoreEventObserving(with: input.loadMoreEvent),
            setupRefreshEventObserving(with: input.refreshEvent)
        )
        
        let output = Output(
            itemsEvent: itemsRelay.asObservable(),
            loadingEvent: loadingRelay.asDriver()
        )
        
        loadHistorySubject.onNext(())
        
        outputHandler(output)
    }
    
    private func setupHistoryTypeEventObserving(with signal: RxObservable<HistoryRaceType>) -> Disposable {
        signal
            .distinctUntilChanged()
            .bind(to: historyTypeSubject)
    }
    
    private func setupMyHistorySelected() -> Disposable {
        historyTypeSubject.asObservable()
            .filter { $0 == .my }
            .subscribe(onNext: { [weak self] response in
                self?.offset = 0
                self?.itemsRelay.accept([])
                self?.loadMyHistorySubject.onNext(())
            })
    }
    
    private func setupHistorySelected() -> Disposable {
        historyTypeSubject.asObservable()
            .filter { $0 == .all }
            .subscribe(onNext: { [weak self] response in
                self?.offset = 0
                self?.itemsRelay.accept([])
                self?.loadHistorySubject.onNext(())
            })
    }
    
    private func setupLoadMyHistoryItems() -> Disposable {
        loadMyHistorySubject.asObservable()
            .flatMap { [weak self] _ in
                guard let self = self else { return Observable<ChingariRaceMyHistoryResponseModel>.never() }
                
                self.loadingRelay.accept(true)
                return injections.networkService.myHistory(requestData: .init(offset: offset, limit: step))
                    .asObservable()
            }
            .subscribe(onNext: { [weak self] response in
                var currentItems = self?.itemsRelay.value ?? []
                let items = response.data.map { RaceHistoryCellViewModel(with: $0) }
                currentItems.append(contentsOf: items)
                self?.itemsRelay.accept(currentItems)
                self?.loadingRelay.accept(false)
            })
    }
    
    private func setupLoadHistoryItems() -> Disposable {
        loadHistorySubject.asObservable()
            .flatMap { [weak self] _ in
                guard let self = self else { return Observable<ChingariRaceHistoryResponseModel>.never() }
                
                self.loadingRelay.accept(true)
                return injections.networkService.history(requestData: .init(offset: offset, limit: step))
                    .asObservable()
            }
            .subscribe(onNext: { [weak self] response in
                var currentItems = self?.itemsRelay.value ?? []
                let items = response.data.map { RaceHistoryCellViewModel(with: $0) }
                currentItems.append(contentsOf: items)
                self?.itemsRelay.accept(currentItems)
                self?.loadingRelay.accept(false)
            })
    }
    
    private func setupBackButtonObserving(with signal: RxObservable<Void>) -> Disposable {
        signal
            .subscribe(onNext: { [weak self] in
                self?.dissmissPublisher.onNext(())
            })
    }
    
    private func setupLoadMoreEventObserving(with signal: RxObservable<Void>) -> Disposable {
        signal
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
            self?.offset += 20
            
            let type = self?.historyTypeSubject.value ?? .all
            
            if type == .all {
                self?.loadHistorySubject.onNext(())
            } else {
                self?.loadMyHistorySubject.onNext(())
            }
        })
    }
    
    
    private func setupRefreshEventObserving(with signal: RxObservable<Void>) -> Disposable {
        signal.subscribe(onNext: { [weak self] in
            self?.offset = 0
            self?.itemsRelay.accept([])
            
            let type = self?.historyTypeSubject.value ?? .all
            
            if type == .all {
                self?.loadHistorySubject.onNext(())
            } else {
                self?.loadMyHistorySubject.onNext(())
            }
        })
    }
    
    private func setupModelSelectedObserving(with signal: RxObservable<RaceHistoryCellViewModel>) -> Disposable {
        signal
            .subscribe(onNext: { [weak self] model in
                self?.redirectToDetailsPublisher.onNext(model.id)
            })
    }
    
}

