//
//  RankDetailsCell.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit


class RankDetailsCell: CollectionViewCell {
    
    private let containerView = UIView()
    
    private let infoContainerView = UIView()
    
    private let carImageView = UIImageView()
    
    private let infoLabel = UILabel()
    
    private(set) var leftButton = UIButton()
    
    private(set) var rightButton = UIButton()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())

    var model: RankDetailsCellViewModel!
    
    override func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        infoLabel.customizer
            .set(font: .init(font: .poppinsMedium, style: .subheadline))
            .set(textColor: .black)
            .set(textAlignment: .center)
        
        carImageView.contentMode = .scaleAspectFit
        
        leftButton.setImage(UIImage(named: CarRaceGameConstants.Images.arrowLeft), for: .normal)
        leftButton.contentHorizontalAlignment = .leading
        
        rightButton.setImage(UIImage(named: CarRaceGameConstants.Images.arrowRight), for: .normal)
        rightButton.contentHorizontalAlignment = .trailing
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        collectionView.collectionViewLayout = flowLayout
        collectionView.isPagingEnabled = true
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerCellClass(RoadRankCell.self)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func setupConstraints() {
        contentView.addSubview(containerView)
        
        containerView.addSubviews([infoContainerView, collectionView])
        infoContainerView.addSubviews([carImageView, infoLabel, leftButton, rightButton])
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        infoContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
        
        carImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.width.height.equalTo(170)
            $0.centerX.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(carImageView.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(infoContainerView.snp.bottom).offset(15)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func render(with model: RankDetailsCellViewModel) {
        self.model = model
        
        carImageView.image = nil
        if let url = URL(string: model.imageUrl) {
            carImageView.sd_setImage(with: url)
        }
        
        leftButton.isHidden = model.isFirst
        rightButton.isHidden = model.isLast
        
        infoLabel.text = "Victory: \(model.winrate) | Odds: \(model.odds)"
        collectionView.reloadData()
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}

extension RankDetailsCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.roadModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ofType: RoadRankCell.self, at: indexPath)
        cell.render(with: model.roadModels[indexPath.row])
        return cell
    }
    
}
    
extension RankDetailsCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 32
        let spacing: CGFloat = 20
        let collectionViewSize = UIScreen.main.bounds.width - padding - spacing
        let width = collectionViewSize / 2
        return CGSize(width: width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
