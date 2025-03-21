//
//  ChingariRaceSocketHandler.swift
//  chingari
//
//  Created by Sergey Pritula on 23.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation
import SocketIO
import RxSwift

typealias EmptyCompletion = () -> ()
typealias ErrorCompletion = (String) -> ()

protocol ChingariRaceSocketHandlerProtocol: SocketActionEmittable {
    
    var sessionUpdatedEvent: PublishSubject<BERaceSessionUpdated> { get }
    
    func subscribeOnSessionUpdate()
    func unsubscribeSessionUpdate()
    
    func connectAndExecute<T>(token: String, action: Single<T>, completion: EmptyCompletion?) -> Single<T>
    func connect(with token: String, completion: EmptyCompletion?)
    func disconnect()
}

final class ChingariRaceSocketHandler: BaseSocketHandler, ChingariRaceSocketHandlerProtocol, SocketConfigurationProducible, SocketEventDataProcessable  {
    
    struct AuthData: Codable {
        let token: String
        let platform: String
        let appId: String
        let deviceId: String
        let appVersion: String
        let packageName: String
        
        init(token: String, appId: String) {
            self.token = token
            self.platform = "ios"
            self.appId = appId
            self.deviceId = UUID.uuid
            self.appVersion = "1.0.0"
            self.packageName = "io.chingari.games.ios"
        }
    }
    
    private var configuration: SocketIOClientConfiguration = []
    
    private let socketConnectedEvent = PublishSubject<(Error?)>()
    private let socketErrorEvent = PublishSubject<(Error?)>()
    private(set) var connectionStateChangedEvent = PublishSubject<SocketIOStatus>()
    
    var sessionUpdatedEvent = PublishSubject<BERaceSessionUpdated>()
    
    convenience init(token: String, isTestEnv: Bool) {
        let config: NetworkConfigProtocol = isTestEnv ? NetworkConfigDev(): NetworkConfigProd()
        self.init(url: config.baseUrl, headers: [
            "token": token,
            "platform": "ios",
            "appId": TokenStorage.shared.appId ?? "",
            "deviceId": UUID.uuid,
            "appVersion": "1.0.0",
            "packageName": Constants.packageName
        ])
    }
    
    override func subscribe() {
        super.subscribe()
        
        // MARK: - Service events
        
        socket?.on(clientEvent: .connect) { [weak self] _, _ in
            self?.socketConnectedEvent.onNext(nil)
        }
        
        socket?.on(clientEvent: .statusChange) { [weak self] data, ack in
            guard let status = data.first as? SocketIOStatus else { return }
            self?.connectionStateChangedEvent.onNext(status)
        }
        
        socket?.on(clientEvent: .error, callback: { data,ack in
            let error = RoomCustomError.generalError
            self.socketErrorEvent.onNext(error)
        })
        
        socket?.on(clientEvent: .disconnect) { [weak self] _, _ in
            guard let self = self else { return }
            let error = RoomCustomError.socketDisconnected
            self.socketErrorEvent.onNext(error)
        }
        
        socket?.on(clientEvent: .reconnect) { [weak self]  _, _  in
            self?.connectionStateChangedEvent.onNext(.connecting)
            self?.forceReconnect()
        }
    }
    
    func forceReconnect() {
        socket?.disconnect()
        unsubscribeSessionUpdate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.connect(with: TokenStorage.shared.token ?? "", completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.subscribeOnSessionUpdate()
            })
        }
    }
    
    func subscribeOnSessionUpdate() {
        socket?.on(Event.raceGameSessionUpdated.rawValue, callback: { [weak self] data, ack in
            guard let model: BERaceSessionUpdated = self?.processEventData(data: data) else { return }
            self?.sessionUpdatedEvent.onNext(model)
        })
    }
    
    func unsubscribeSessionUpdate() {
        socket?.off(Event.raceGameSessionUpdated.rawValue)
    }
    
    func connect(with token: String, completion: EmptyCompletion?) {
        if self.socket?.status == .connected {
            completion?()
            return
        }
        
        let appId = TokenStorage.shared.appId ?? ""
        let authData = AuthData(token: token, appId: appId)
        let query = ReconnectionQuery(deviceId: UUID.uuid,
                                      appId: appId,
                                      appVersion: "1.0.0",
                                      packageName: Constants.packageName)
        
        let params = query.asDictionary() ?? [:]
        let configuration = self.configuration(with: params)
        self.setInitial(configuration: configuration)
        
        if self.socket?.status != .connected {
            self.socket?.connect(withPayload: authData.asDictionary(), timeoutAfter: 0, withHandler: {
                completion?()
            })
        } else {
            completion?()
        }
    }
    
    func setQuery(for roomId: String, role: String) {
        let query = ReconnectionQuery()
        let params = query.asDictionary() ?? [:]
        let newConfiguration = self.configuration(with: params)
        self.update(configuration: newConfiguration)
    }
    
    func resetQuery() {
        resetToDefaultConfiguration()
    }
    
    override func disconnect() {
        socket?.disconnect()
    }
}

extension ChingariRaceSocketHandler {
    func connectAndExecute<T>(
        token: String, action: Single<T>, completion: EmptyCompletion?
    ) -> Single<T> {
        guard socket?.status != .connected else { return Single.never() }
        connect(with: token, completion: nil)
        return RxObservable.merge(socketConnectedEvent, socketErrorEvent)
            .take(1)
            .asSingle()
            .flatMap { error in
                if let error = error {
                    return .error(error)
                } else {
                    return action
                }
            }
    }
    
}

extension ChingariRaceSocketHandler {
    enum Event: String {
        case raceGameSessionUpdated = "be_racing_game_session_updated"
    }
    
    enum Action: String {
        case joinRaceGame = "fe_racing_game_join"
        case bet = "fe_racing_game_bet"
    }
}
