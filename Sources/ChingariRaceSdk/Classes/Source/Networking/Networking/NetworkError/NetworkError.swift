//
//  NetworkError.swift
//  Networking
//
//  Created by Vorko Dmitriy on 16.05.2021.
//

import Foundation

public enum NetworkError: Error {
    case decodeDataError
    case dataMissed
    case invalidResponseStatusCode(code: Int)
    case serverError(error: String, serverMessage: String?, statusCode: Int?)
    case warning(warning: String)
    case invalidAccessToken(dispatchedToken: String?, serverMessage: String)
}

extension NetworkError: LocalizedError {
    public var apiErrorDescription: String {
        switch self {
        case .decodeDataError:
            return "Decoding data error"

        case .dataMissed:
            return "Missed data in response."

        case let .invalidResponseStatusCode(code):
            return "Failed status code response: \(code)"

        case let .serverError(error, serverMessage, _):
            return serverMessage ?? error

        case let .warning(warning):
            return "Warning: \(warning)"

        case let .invalidAccessToken(dispatchedToken, serverMessage):
            return
                """
                Invalid Access TOKEN:  \(dispatchedToken ?? "TOKEN IS NIL"),
                Server message: \(serverMessage)"
                """
        }
    }
    
    public var code: Int {
        switch self {
        case let .serverError(_, _, code):
            return code ?? -1997
        default:
            return -1998
        }
    }
}

public enum NetworkErrorWithData<T>: Error {
    case serverError(error: String, serverMessage: String?, data: T?)
}
