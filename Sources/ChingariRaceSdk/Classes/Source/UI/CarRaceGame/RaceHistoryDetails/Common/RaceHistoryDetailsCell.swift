//
//  RaceHistoryDetailsCell.swift
//  chingari
//
//  Created by Sergey Pritula on 26.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit

class RaceHistoryDetailsCell: TableViewCell {
    
    private let containerView = UIView()
    
    private let stackView = UIStackView()
    
    private let indexContainerView = UIView()
    
    private let indexLabel = UILabel()
    
    private let userContainerView = UIView()
    
    private let avatarView = UIImageView()
    
    private let counrtyImage = UIImageView()
    
    private let usernameLabel = UILabel()
    
    private let totalContainerView = UIView()
    
    private let totalStackView = UIStackView()
    
    private let totalDiamondImageView = UIImageView()
    
    private let totalLabel = UILabel()
    
    private let spendContainerView = UIView()
    
    private let spendStackView = UIStackView()
    
    private let spendDiamondImageView = UIImageView()
    
    private let spendLabel = UILabel()
    
    private let prizesContainerView = UIView()
    
    private let prizesStackView = UIStackView()
    
    private let prizesDiamondImageView = UIImageView()
    
    private let prizesLabel = UILabel()
    
    override func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        stackView.customizer
            .set(distribution: .fill)
            .set(spacing: 0)
            .set(axis: .horizontal)
        
        [totalStackView, spendStackView, prizesStackView].forEach {
            $0.customizer
                .set(distribution: .fill)
                .set(spacing: 2)
                .set(axis: .horizontal)
        }
        
        avatarView.customizer
            .set(backgroundColor: .lightGray)
            .set(cornerRadius: 12)
        
        counrtyImage.customizer
            .set(backgroundColor: .lightGray)
            .set(cornerRadius: 6)
        
        indexLabel.customizer
            .set(textColor: .black)
            .set(font: .init(font: .poppinsMedium, style: .caption2))
        
        usernameLabel.customizer
            .set(textColor: UIColor(hexString: "#815EF2"))
            .set(font: .init(font: .poppinsRegular, style: .caption2))
        
        [totalDiamondImageView, spendDiamondImageView, prizesDiamondImageView].forEach {
            $0.customizer
                .set(image: UIImage(named: CarRaceGameConstants.Images.diamond))
                .set(contentMode: .scaleAspectFit)
        }
        
        [totalLabel, spendLabel, prizesLabel].forEach {
            $0.customizer
                .set(font: .init(font: .poppinsRegular, style: .caption2))
                .set(textColor: UIColor(hexString: "#815EF2"))
        }
    }
    
    override func setupConstraints() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(stackView)
        
        containerView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(indexContainerView)
        stackView.addArrangedSubview(userContainerView)
        stackView.addArrangedSubview(totalContainerView)
        stackView.addArrangedSubview(spendContainerView)
        stackView.addArrangedSubview(prizesContainerView)
        
        indexContainerView.addSubview(indexLabel)
        userContainerView.addSubviews([avatarView, counrtyImage, usernameLabel])
        totalContainerView.addSubview(totalStackView)
        spendContainerView.addSubview(spendStackView)
        prizesContainerView.addSubview(prizesStackView)
        
        totalStackView.addArrangedSubview(totalDiamondImageView)
        totalStackView.addArrangedSubview(totalLabel)
        
        spendStackView.addArrangedSubview(spendDiamondImageView)
        spendStackView.addArrangedSubview(spendLabel)
        
        prizesStackView.addArrangedSubview(prizesDiamondImageView)
        prizesStackView.addArrangedSubview(prizesLabel)
        
        indexContainerView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.1)
        }
        
        userContainerView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.3)
        }
        
        totalContainerView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.2)
        }
        
        spendContainerView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.2)
        }
        
        prizesContainerView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.2)
        }
        
        indexLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        [totalStackView, spendStackView, prizesStackView].forEach {
            $0.snp.makeConstraints { $0.center.equalToSuperview() }
        }
        
        [totalDiamondImageView, spendDiamondImageView, prizesDiamondImageView].forEach {
            $0.snp.makeConstraints { $0.width.height.equalTo(12) }
        }
        
        avatarView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.top.equalToSuperview().offset(7)
            $0.width.height.equalTo(24)
        }
        
        usernameLabel.snp.makeConstraints {
            $0.leading.equalTo(avatarView.snp.trailing).offset(4)
            $0.trailing.equalToSuperview()
            $0.top.equalTo(avatarView)
        }
        
        counrtyImage.snp.makeConstraints {
            $0.leading.equalTo(usernameLabel)
            $0.top.equalTo(usernameLabel.snp.bottom).offset(2)
            $0.width.height.equalTo(12)
        }
    }
    
    func render(with viewModel: RaceHistoryDetailsCellViewModel, index: Int) {
        if index == 0 {
            containerView.backgroundColor = UIColor(hexString: "#815EF2").withAlphaComponent(0.24)
        } else if index % 2 == 0 {
            containerView.backgroundColor = UIColor(hexString: "#815EF2").withAlphaComponent(0.04)
        } else {
            containerView.backgroundColor = .clear
        }
        
        let model = viewModel.model
        indexLabel.text = "\(model.rank)"
        usernameLabel.text = model.userName
        spendLabel.text = String(model.winnerBetSpend)
        totalLabel.text = String(model.totalSpend)
        prizesLabel.text = String(model.prize)
        
        counrtyImage.layer.cornerRadius = 6
        counrtyImage.clipsToBounds = true
        
        if let image = CountryManager.shared.country(withCode: model.country ?? "")?.flag {
            counrtyImage.image = image
        } else {
            counrtyImage.isHidden = true
        }
        
        avatarView.clipsToBounds = true
        avatarView.image = nil
        if let imageUrl = model.userImage, let url = URL(string: imageUrl) {
            avatarView.sd_setImage(with: url)
        }
    }
}

class RaceHistoryDetailsCellViewModel {
    let model: ChingariRaceSesssionLeaderboardDTO
    
    init(from model: ChingariRaceSesssionLeaderboardDTO) {
        self.model = model
    }
}
