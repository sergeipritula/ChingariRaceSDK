//
//  TokenStorage.swift
//  ChingariRaceTest
//
//  Created by Sergey Pritula on 13.03.2025.
//

import Foundation

class TokenStorage {
    var appId: String?
    var token: String?
    var userId: String?
    
    private init() {}
    
    static let shared = TokenStorage()
    
    func set(token: String) {
        self.token = token
    }
    
    func set(appId: String) {
        self.appId = appId
    }
    
    func set(userId: String) {
        self.userId = userId
    }
}
