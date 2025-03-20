//
//  ReconnectionHeader.swift
//  chingari
//
//  Created by Andrey Krit on 12.07.2022.
//  Copyright © 2022 Nikola Milic. All rights reserved.
//

import UIKit

struct ReconnectionQuery: Encodable {
    
    private let deviceId: String?
    private let appId: String?
    private let platform: String?
    private let appVersion: String?
    private let packageName: String?
    
    init(deviceId: String? = nil,
         appId: String? = nil,
         platform: String? = nil,
         appVersion: String? = nil,
         packageName: String? = nil
    ) {
        self.deviceId = deviceId
        self.appId = appId
        self.platform = platform
        self.appVersion = appVersion
        self.packageName = packageName
    }
    
    
    
}
