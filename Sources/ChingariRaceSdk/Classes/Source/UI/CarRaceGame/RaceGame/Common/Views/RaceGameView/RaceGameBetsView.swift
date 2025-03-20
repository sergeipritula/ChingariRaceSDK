//
//  RaceGameBetsView.swift
//  chingari
//
//  Created by Sergey Pritula on 12.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit

class RaceGameBetsView: CHView {
    
    private let containerView = UIView()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var items: [BetCarCellViewModel] = []
    
    override func setupView() {
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        collectionView.backgroundColor = .clear
        
        collectionView.registerCellClass(RaceBetCell.self)
        collectionView.showsVerticalScrollIndicator = false
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.clipsToBounds = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(collectionView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(45)
        }
    }
    
    func render(items: [BetCarCellViewModel]) {
        self.items = items
        self.collectionView.reloadData()
    }
}

extension RaceGameBetsView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ofType: RaceBetCell.self, at: indexPath)
        cell.render(with: items[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RaceGameBetsView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 32
        let spacing: CGFloat = 9
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
