//
//  SocketAck.swift
//  chingari
//
//  Created by Andrey Krit on 08.08.2022.
//  Copyright © 2022 Nikola Milic. All rights reserved.
//

import Foundation

struct SocketAckData<T: Decodable>: Decodable {
    let data: T
}

struct EmptySocketAck: Codable {
    
    enum Result: String, Codable {
        case success
        case failure
    }
    
    let message: Result
}
