//
//  BaseSocketHandler.swift
//  chingari
//
//  Created by Softermii-User on 17.05.2022.
//  Copyright © 2022 Nikola Milic. All rights reserved.
//

import Foundation
import SocketIO

class BaseSocketHandler {
    
    private var manager: SocketManager?
    private var configuration: SocketIOClientConfiguration
    
    var socket: SocketIOClient? {
        return manager?.defaultSocket
    }
    
    init(url: String, headers: [String: String] = [:]) {
        self.configuration = []
        self.manager = startManager(url: url, headers: headers)
        self.subscribe()
    }
    
    private func startManager(url: String, headers: [String: String] = [:]) -> SocketManager? {
        guard let url = url.toUrl() else { return nil }
    
        let manager = SocketManager(socketURL: url, config: [
            .log(false),
            .reconnects(true),
            .reconnectAttempts(-1),
            .reconnectWait(5),
            .extraHeaders(headers)])
        
        return manager
    }
    
    func subscribe() {
        
    }
    
    func connect() {
        if socket?.status != .connected {
            socket?.connect()
        }
    }

    func disconnect() {
        if socket?.status == .connected {
            socket?.disconnect()
        }
    }
    
    func setInitial(configuration: SocketIOClientConfiguration) {
        self.configuration = configuration
        manager?.setConfigs(configuration)
    }
    
    func update(configuration: SocketIOClientConfiguration) {
        manager?.setConfigs(configuration)
    }
    
    func resetToDefaultConfiguration() {
        manager?.setConfigs(configuration)
    }

}
