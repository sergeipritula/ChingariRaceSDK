//
//  AuthorizationTokenProvider.swift
//  Networking
//
//  Created by Vorko Dmitriy on 16.05.2021.
//

import Foundation

public protocol AuthorizationTokenProvider {
    func authorizationToken() -> String?
}
