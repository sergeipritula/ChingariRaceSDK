//
//  Constants.swift
//  ChingariRaceTest
//
//  Created by Sergey Pritula on 13.03.2025.
//

import Foundation

protocol NetworkConfigProtocol {
    var baseUrl: String { get }
    var isProduction: Bool { get }
}

class NetworkConfigDev: NetworkConfigProtocol {
    var baseUrl: String {
        return "https://dev-carrace.chingari.io/"
    }
    
    var isProduction: Bool {
        return false
    }
}

class NetworkConfigProd: NetworkConfigProtocol {
    var baseUrl: String {
        return "https://carrace.chingari.io/"
    }
    
    var isProduction: Bool {
        return true
    }
}
