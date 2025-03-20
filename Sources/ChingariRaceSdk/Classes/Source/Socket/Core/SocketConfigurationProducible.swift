//
//  SocketConfigurationProducible.swift
//  chingari
//
//  Created by Andrey Krit on 24.01.2023.
//  Copyright © 2023 Nikola Milic. All rights reserved.
//

import SocketIO

protocol SocketConfigurationProducible {}

extension SocketConfigurationProducible {
    func configuration(with headerParams: [String:Any]) -> SocketIOClientConfiguration {
        return [
            .log(false),
            .forceNew(true),
            .reconnects(true),
            .secure(true),
            .forceWebsockets(true),
            .connectParams(headerParams)
        ]
    }
}
