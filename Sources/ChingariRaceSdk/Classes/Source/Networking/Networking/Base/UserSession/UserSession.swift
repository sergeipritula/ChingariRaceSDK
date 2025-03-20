//
//  UserSession.swift
//  AdButler
//
//  Created by Chingari MacBook Pro 16 on 19/05/23.
//

import RxSwift
import RxCocoa
import UIKit

internal class UserSession {
    private static var shared: UserSession = .init()
    public static var userSessionId: String { UserSession.shared.userSessionId }
    private let disposeBag = DisposeBag()
    private var userSessionId: String
    
    private init() {
        userSessionId = UUID().uuidString
        setupBindings()
    }
    
    private func setupBindings() {
        disposeBag.insert([
            setupWillEnterForeground()
        ])
    }
    
    private func setupWillEnterForeground() -> Disposable {
        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .subscribe(with: self, onNext: {`self`, _ in
                self.userSessionId = UUID().uuidString
            })
    }
}
