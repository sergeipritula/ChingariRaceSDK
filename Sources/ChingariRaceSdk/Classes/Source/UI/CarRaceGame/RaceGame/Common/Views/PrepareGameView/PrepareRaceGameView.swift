//
//  RaceGameView.swift
//  chingari
//
//  Created by Sergey Pritula on 24.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PrepareRaceGameView: CHView {
    
    private let containerView = UIView()
    
    private(set) var header = PrepareRaceGameHeaderView()
    
    private(set) var roadsView = RaceRoadsView()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    private(set) var footer = PrepareRaceGameFooterView()
    
    let itemsRelay: BehaviorRelay<[BetCarCellViewModel]> = .init(value: [])
    let sessionSubject: PublishSubject<ChingariRaceSession> = .init()
    
    private let selectSubject: PublishSubject<BetCarCellViewModel> = .init()
    var selectEvent: RxObservable<BetCarCellViewModel> { selectSubject }
    
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupView()
        setupConstraints()
        setupBindings()
    }
    
    override func setupView() {
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        collectionView.backgroundColor = .clear
        
        collectionView.registerCellClass(BetCarCell.self)
        collectionView.showsVerticalScrollIndicator = false
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.clipsToBounds = false
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(header)
        containerView.addSubview(roadsView)
        containerView.addSubview(collectionView)
        containerView.addSubview(footer)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        header.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        roadsView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(6)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(roadsView.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(footer.snp.top).offset(-10)
        }
        
        footer.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        disposeBag.insert([
            setupDelegateObserving(),
            setupSessionUpdatedPublisher(),
            setupItems(),
            setupModelSelectedObserving()
        ])
    }
    
    private func setupItems() -> Disposable {
        itemsRelay
            .asDriverOnErrorJustComplete()
            .drive(collectionView.rx.items) { collectionView, row, model -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(ofType: BetCarCell.self, at: IndexPath(row: row))
                cell.render(with: model)
                return cell
            }
    }
    
    private func setupDelegateObserving() -> Disposable {
        collectionView.rx.setDelegate(self)
    }
    
    private func setupModelSelectedObserving() -> Disposable {
        collectionView.rx.modelSelected(BetCarCellViewModel.self).bind(to: selectSubject)
    }
    
    private func setupSessionUpdatedPublisher() -> Disposable {
        sessionSubject.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (self, session) in
                self.header.sessionUpdated(session: session)
                self.footer.sessionUpdated(with: session)
                self.roadsView.render(roads: session.road)
            })
    }
    
}
    
// MARK: - UICollectionViewDelegateFlowLayout

extension PrepareRaceGameView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 32
        let spacing: CGFloat = 10
        let collectionViewSize = UIScreen.main.bounds.width - padding - spacing
        let width = collectionViewSize / 3
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
