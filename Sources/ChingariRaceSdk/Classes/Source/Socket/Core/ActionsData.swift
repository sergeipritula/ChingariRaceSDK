//
//  JoinRoomAction.swift
//  chingari
//
//  Created by Softermii-User on 24.05.2022.
//  Copyright © 2022 Nikola Milic. All rights reserved.
//

import Foundation
import SocketIO

protocol SocketEncodable: SocketData, Encodable {}

extension SocketEncodable {
    
    func socketRepresentation() -> SocketData {
        self.asDictionary() ?? [:]
    }
    
}
