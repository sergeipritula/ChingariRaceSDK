//
//  ChingariRaceService.swift
//  chingari
//
//  Created by Sergey Pritula on 23.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//


import Foundation
import RxSwift

struct FEBetBalanceModel: Codable {
    let data: FEBalanceData
    
    struct FEBalanceData: Codable {
        let balance: Int
    }
}

struct FEBetsModel: SocketEncodable {
    let bets: [FEBetModel]
}

struct FEBetModel: SocketEncodable {
    let carBetId: String
    let amount: Int
}

protocol ChingariRaceServiceProtocol {
    var sessionUpdatedObservable: RxObservable<BERaceSessionUpdated> { get }
    
    func connect(completion: @escaping (() -> ()))
    func connect()
    func disconnect()
    
    func subscribeOnSessionUpdate()
    func unsubscribeSessionUpdate()

    func joinRaceGame(data: FEChingariRaceJoinModel) -> Single<BERaceGameJoinModel>
    func sendBets(bets: FEBetsModel) -> Single<FEBetBalanceModel>
}

class ChingariRaceService: ChingariRaceServiceProtocol {
    
    private let signalingManager: ChingariRaceSocketHandlerProtocol
    private let tokenProvider: AuthorizationTokenProvider
    
    private var sessionUpdatedPublisher = PublishSubject<BERaceSessionUpdated>()
    private let disposeBag = DisposeBag()
    
    init(tokenProvider: AuthorizationTokenProvider, isTestEnv: Bool) {
        self.tokenProvider = tokenProvider
        self.signalingManager = ChingariRaceSocketHandler(token: tokenProvider.authorizationToken() ?? "",
                                                          isTestEnv: isTestEnv)
        configureBindings()
    }
    
    private func configureBindings() {
        signalingManager.sessionUpdatedEvent
            .bind(to: sessionUpdatedPublisher)
            .disposed(by: disposeBag)
    }
    
    func connect(completion: @escaping (() -> ())) {
        guard let token = tokenProvider.authorizationToken() else { return }
        signalingManager.connect(with: token, completion: completion)
    }
    
    func connect() {
        guard let token = tokenProvider.authorizationToken() else { return }
        signalingManager.connect(with: token, completion: nil)
    }
    
    func disconnect() {
        signalingManager.disconnect()
    }
    
    func joinRaceGame(data: FEChingariRaceJoinModel) -> Single<BERaceGameJoinModel> {
        signalingManager
            .emitAction(.joinRaceGame, data: data, ackType: BERaceGameJoinModel.self)
            .map { $0 }
    }
    
    func sendBets(bets: FEBetsModel) -> Single<FEBetBalanceModel> {
        signalingManager
            .emitAction(.bet, data: bets, ackType: FEBetBalanceModel.self)
            .map { $0 }
    }
    
    func subscribeOnSessionUpdate() {
        signalingManager.subscribeOnSessionUpdate()
    }
    
    func unsubscribeSessionUpdate() {
        signalingManager.unsubscribeSessionUpdate()
    }

}

extension ChingariRaceService {
    
    var sessionUpdatedObservable: RxObservable<BERaceSessionUpdated> {
        sessionUpdatedPublisher.asObservable()
    }
    
}
