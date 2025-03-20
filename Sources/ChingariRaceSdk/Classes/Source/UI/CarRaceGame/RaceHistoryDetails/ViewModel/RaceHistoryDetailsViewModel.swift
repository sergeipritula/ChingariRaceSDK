//
//  RaceHistoryDetailsViewModel.swift
//  chingari
//
//  Created by Sergey Pritula on 26.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RaceHistoryDetailsViewModel: DeinitAnnouncerType {
    
    private let networkService: ChingariRaceNetworkServiceProtocol
    
    private let sessionId: String
    
    private let loadingRelay = BehaviorRelay<Bool>(value: false)
    
    private(set) var dismissPublisher = PublishSubject<Void>()
    
    private let itemsRelay = BehaviorRelay<[RaceHistoryDetailsCellViewModel]>(value: [])
    
    private let sessionPublisher = PublishSubject<ChingariRaceSessionDetailsDTO>()
    
    private let myWinnerPublishSubject = PublishSubject<ChingariRaceSesssionLeaderboardDTO?>()
    
    struct Injections {
        let networkService: ChingariRaceNetworkServiceProtocol
        let sessionId: String
    }
    
    init(injections: Injections) {
        self.networkService = injections.networkService
        self.sessionId = injections.sessionId
        setupDeinitAnnouncer()
    }
    
}

// MARK: - ViewModelProtocol

extension RaceHistoryDetailsViewModel: ViewModelProtocol {
    
    struct Input {
        let backEvent: RxObservable<Void>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let loading: Driver<Bool>
        let items: RxObservable<[RaceHistoryDetailsCellViewModel]>
        let winner: RxObservable<ChingariRaceSesssionLeaderboardDTO?>
        let session: RxObservable<ChingariRaceSessionDetailsDTO>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert(
            setupFetchSessionDetailsObserving(),
            setupBackButtonObserving(with: input.backEvent)
        )
        
        let output = Output(
            loading: loadingRelay.asDriver(),
            items: itemsRelay.asObservable(),
            winner: myWinnerPublishSubject.asObservable(),
            session: sessionPublisher.asObservable()
        )
        outputHandler(output)
    }
    
    private func setupFetchSessionDetailsObserving() -> Disposable {
        loadingRelay.accept(true)
        
        return networkService
            .sessionDetails(requestData: .init(offset: 0, limit: 20, sessionId: self.sessionId))
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (self, response) in
                let items = response.data.leaderboard.map { RaceHistoryDetailsCellViewModel(from: $0) }
                let winner = response.data.myWinner
                
                self.sessionPublisher.onNext(response.data)
                self.myWinnerPublishSubject.onNext(winner)
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
