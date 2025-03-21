//
//  WinRateRankCell.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit

class WinRateRankCell: CollectionViewCell {
    
    private let containerView = UIView()
    
    private let mainView = UIView()
    
    private let carImageView = UIImageView()
    
    private let carLabel = UILabel()
    
    private let infoView = UIView()
    
    private let rateBackgroundImageView = UIImageView()
    
    private let ratePercentLabel = UILabel()
    
    private let speedBackgroundImageView = UIImageView()
    
    private let speedLabel = UILabel()
    
    override func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = .clear
        
        mainView.customizer
            .set(cornerRadius: 10)
            .set(borderWidth: 1)
            .set(borderColor: .white)
            .set(backgroundColor: UIColor(hexString: "#FFF1FF"))
        
        mainView.addShadow(
            with: UIColor(hexString: "#3E1A50").withAlphaComponent(0.08),
            offset: .init(width: 0, height: 1),
            shadowOpacity: 1,
            shadowRadius: 6
        )
        
        carLabel.customizer
            .set(font: .init(font: .poppinsSemiBold, style: .caption1))
            .set(textColor: .black.withAlphaComponent(0.7))
            .set(textAlignment: .center)
        
        ratePercentLabel.customizer
            .set(font: .init(font: .poppinsSemiBold, style: .caption2))
            .set(textColor: .white)
        
        speedLabel.customizer
            .set(font: .init(font: .poppinsSemiBold, style: .caption2))
            .set(textColor: .white)
        
        rateBackgroundImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.orangeBackground, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleToFill)
        
        speedBackgroundImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.purpleBackground, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleToFill)
        
        carImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.monsterTruckSmall, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleAspectFit)
    }
    
    override func setupConstraints() {
        contentView.addSubview(containerView)
        
        containerView.addSubviews([mainView, infoView])
        mainView.addSubviews([carImageView, carLabel])
        infoView.addSubviews([rateBackgroundImageView, ratePercentLabel, speedBackgroundImageView, speedLabel])
        
        rateBackgroundImageView.addSubviews([ratePercentLabel])
        speedBackgroundImageView.addSubviews([speedLabel])
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(infoView.snp.top).offset(10)
        }
        
        infoView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        carImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-10)
            $0.width.height.equalTo(68)
        }
        
        carLabel.snp.makeConstraints {
            $0.top.equalTo(carImageView.snp.bottom).offset(2)
            $0.leading.trailing.equalToSuperview()
        }
        
        rateBackgroundImageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        speedBackgroundImageView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.33)
        }
        
        ratePercentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-15)
        }
        
        speedLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func render(with viewModel: WinRateRankCellViewModel) {
        carImageView.image = nil
        
        if let url = URL(string: viewModel.model.iconFrontThumb) {
            carImageView.sd_setImage(with: url)
        }
        
        carLabel.text = viewModel.model.name
        ratePercentLabel.text = "\(viewModel.model.standartWinRate)%"
        speedLabel.text = viewModel.model.standartOdds.string
    }
    
}
