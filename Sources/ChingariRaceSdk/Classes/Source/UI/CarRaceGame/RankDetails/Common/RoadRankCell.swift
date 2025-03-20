//
//  RoadRankCell.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit

class RoadRankCell: CollectionViewCell {
    
    private let stackView = UIStackView()
    
    private let roadTypeContainer = UIView()
    
    private let roadTypeImageView = UIImageView()
    
    private let backgroundImageView = UIImageView()
    
    private let roadTypeLabel = UILabel()
    
    private let progressView = RankProgressView()
    
    override func setupView() {
        backgroundColor = .clear
        
        stackView.customizer
            .set(axis: .vertical)
            .set(alignment: .leading)
            .set(distribution: .equalSpacing)
        
        roadTypeImageView.customizer
            .set(contentMode: .scaleToFill)
            .set(image: UIImage(named: CarRaceGameConstants.Images.roadRounded))
            .set(borderWidth: 2)
            .set(borderColor: .white)
            .set(cornerRadius: 6)
        
        roadTypeImageView.addShadow(
            with: UIColor(hexString: "#3E1A50").withAlphaComponent(0.12),
            offset: .init(width: 0, height: 1),
            shadowOpacity: 1,
            shadowRadius: 0.7
        )
        
        backgroundImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.roadPurpleBackground))
            .set(contentMode: .scaleToFill)
        
        roadTypeLabel.customizer
            .set(font: .init(font: .poppinsSemiBold, style: .caption2))
            .set(textColor: .white)
            .set(textAlignment: .center)
    }
    
    override func setupConstraints() {
        contentView.addSubview(stackView)
            
        stackView.addArrangedSubview(roadTypeContainer)
        stackView.addArrangedSubview(progressView)
        
        roadTypeContainer.addSubview(roadTypeImageView)
        roadTypeContainer.addSubview(backgroundImageView)
        backgroundImageView.addSubview(roadTypeLabel)
        
        stackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview()
            $0.edges.equalToSuperview()
        }
        
        roadTypeImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(28)
        }
        
        roadTypeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.leading.equalTo(roadTypeImageView.snp.trailing)
            $0.centerY.equalTo(roadTypeImageView)
        }
    }
    
    func render(with model: RoadRankCellViewModel) {
        roadTypeLabel.text = model.roadName
        roadTypeImageView.image = model.imageRounded
        
        progressView.setupLabel(String(Int(model.capability * 100)))
        progressView.setupProgress(model.capability)
    }
}
