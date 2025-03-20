//
//  SocketActionEmittable.swift
//  chingari
//
//  Created by Softermii-User on 17.05.2022.
//  Copyright © 2022 Nikola Milic. All rights reserved.
//

import SocketIO
import RxSwift
import Foundation

protocol SocketActionEmittable: AnyObject {
    var socket: SocketIOClient? { get }
}

extension SocketActionEmittable {
    
    fileprivate func emit<T: Decodable, Action: RawRepresentable>(action: Action, data: SocketData?, ackType: T.Type, timeout: Double) -> Single<T> where Action.RawValue == String {
        return Single.create { [weak self] event -> Disposable in
            
            self?.socket?.emitWithAck(action.rawValue, data ?? [:]).timingOut(after: timeout) { message in
                
                if let dict = message.first as? [String:Any],
                   let data = try? JSONSerialization.data(withJSONObject: dict,
                                                          options: .prettyPrinted),
                   let model = try? JSONDecoder().decode(T.self, from: data)
                {
                    event(.success(model))
                    
                } else if let dict = message.first as? [[String:Any]],
                          let data = try? JSONSerialization.data(withJSONObject: dict),
                          let model = try? JSONDecoder().decode(T.self, from: data)
                {
                    event(.success(model))
                } else {
                    guard let error = self?.processError(message: message) else {
                        event(.failure(RoomCustomError.generalError))
                        return
                    }
                    event(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    private func processError(message: [Any]?) -> Error {
        
        if let dict = message?.first as? [String: Any],
           let data = try? JSONSerialization.data(withJSONObject: dict),
           let errorData = try? JSONDecoder().decode(RoomSocketErrorModel.self, from: data)
        {
            return errorData.error
        } else {
            return RoomCustomError.generalError
        }
        
    }
}

protocol SocketEventDataProcessable {}

extension SocketEventDataProcessable {
    
    func processEventData<T: Decodable>(data: [Any]) -> T? {
        guard let dict = data.first as? [String: Any] else {
            print("Error: First element is not a dictionary.")
            return nil
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict)
            let model = try JSONDecoder().decode(T.self, from: jsonData)
            return model
        } catch {
            return nil
        }
    }
    
}
 
// MARK: - ChingariRaceSocketHandlerProtocol

extension ChingariRaceSocketHandlerProtocol {
    func emitAction<T: Decodable>(_ action: ChingariRaceSocketHandler.Action, data: SocketData = [:], ackType: T.Type = EmptySocketAck.self, timeout: Double = 20) -> Single<T> {
        return emit(action: action, data: data, ackType: ackType, timeout: timeout)
    }
}
