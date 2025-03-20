//
//  CHBaseCoordinator.swift
//  chingari
//
//  Created by Chingari MacBook Pro 16 on 20/06/22.
//  Copyright © 2022 Nikola Milic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CHBaseCoordinator<ResultType>: NSObject, DeinitAnnouncerType {
    
    typealias CoordinationResult = ResultType
    let disposeBag = DisposeBag()
    private let identifier = UUID()
    private var childCoordinators = [UUID: Any]()
    
    override init() {
        super.init()
        setupDeinitAnnouncer()
    }

    private func store<T>(coordinator: CHBaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func free<T>(coordinator: CHBaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

    func coordinate<T>(to coordinator: CHBaseCoordinator<T>) -> RxObservable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .withUnretained(coordinator)
            .do(onNext: { [weak self] coordinator, _ in
                self?.free(coordinator: coordinator)
            }).map { $0.1 }
    }

    func start() -> RxObservable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}

extension CHBaseCoordinator {
    
    func freeAllChildCoordinators() {
        childCoordinators = [:]
    }
}
