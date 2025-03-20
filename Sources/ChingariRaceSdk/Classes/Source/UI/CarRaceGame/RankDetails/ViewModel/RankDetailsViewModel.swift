//
//  RankDetailsViewModel.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RankDetailsViewModel: DeinitAnnouncerType {
    
    struct Injections {
        let cars: [Car]
        let index: Int
    }
    
    private(set) var currentIndex: Int
    private let cars: [Car]
    private let carPublisher = PublishSubject<Car>()
    
    private(set) var cellModels: [RankDetailsCellViewModel]
        
    var dismissPublisher = PublishSubject<Void>()
    
    init(injections: Injections) {
        self.currentIndex = injections.index
        self.cars = injections.cars
        
        self.cellModels = []
        
        for i in 0..<injections.cars.count {
            let model = RankDetailsCellViewModel(
                from: injections.cars[i],
                isFirst: i == 0,
                isLast: i == injections.cars.count - 1)
            cellModels.append(model)
        }
        
        setupDeinitAnnouncer()
    }
 
    func moveLeft() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
    
    func moveRight() {
        if currentIndex < cars.count - 1 {
            currentIndex += 1
        }
    }
    
    func setIndex(_ index: Int) {
        currentIndex = index
    }
}

extension RankDetailsViewModel: ViewModelProtocol {
    
    struct Input {
        let backEvent: RxObservable<Void>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let carEvent: RxObservable<Car>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setupBackButtonObserving(with: input.backEvent)
        ])
        
        let output = Output(
            carEvent: carPublisher.asObservable()
        )
        
        outputHandler(output)
    }
    
    private func setupBackButtonObserving(with signal: RxObservable<Void>) -> Disposable {
        signal
            .subscribe(onNext: { [weak self] in
                self?.dismissPublisher.onNext(())
            })
    }
}
