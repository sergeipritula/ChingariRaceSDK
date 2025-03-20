//
//  RaceHistoryStatsView.swift
//  chingari
//
//  Created by Sergey Pritula on 26.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit

class RaceHistoryStatsView: CHView {
    
    private let containerView = UIView()
    
    private let stackView = UIStackView()
    
    private let ammountLabel = UILabel()
    
    private let infoStackView = UIStackView()
    
    private let participantContainerView = UIView()
    
    private let participantStackView = UIStackView()
    
    private let personImageView = UIImageView()
    
    private let participantsCountLabel = UILabel()
    
    private let diamondsContainerView = UIView()
    
    private let diamondStackView = UIStackView()
    
    private let diamondsImageView = UIImageView()
    
    private let diamondsLabel = UILabel()
    
    private let tipLabel = UILabel()
    
    private let carContainerView = UIView()
    
    private let carImageView = UIImageView()
    
    private let badgeView = UIView()
    
    private let statsLabel = UILabel()
    
    override func setupView() {
        backgroundColor = .clear
        
        containerView.customizer
            .set(cornerRadius: 12)
            .set(borderWidth: 1)
            .set(borderColor: UIColor(hexString: "#815EF2"))
        
        stackView.customizer
            .set(axis: .vertical)
            .set(distribution: .equalSpacing)
            .set(alignment: .fill)
        
        infoStackView.customizer
            .set(axis: .horizontal)
            .set(spacing: 10)
            .set(distribution: .fillEqually)
        
        [participantsCountLabel, diamondsLabel, ammountLabel].forEach {
            $0.customizer
                .set(font: .init(font: .poppinsRegular, style: .caption2))
                .set(textColor: UIColor(hexString: "#551C88"))
        }
        
        [participantStackView, diamondStackView].forEach {
            $0.customizer
                .set(axis: .horizontal)
                .set(spacing: 2)
                .set(distribution: .fill)
        }
        
        ammountLabel.customizer
            .set(textAlignment: .center)
        
        personImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.person))
            .set(contentMode: .scaleAspectFit)
        
        diamondsImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.diamond))
            .set(contentMode: .scaleAspectFit)
        
        carImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.monsterTruckSmall))
            .set(contentMode: .scaleAspectFit)

        badgeView.customizer
            .set(backgroundColor: UIColor(hexString: "#815EF2"))
            .set(cornerRadius: 6)
        
        statsLabel.customizer
            .set(font: .init(font: .poppinsRegular, style: .caption2))
            .set(textColor: .white)
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(stackView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        stackView.addArrangedSubview(ammountLabel)
        stackView.addArrangedSubview(infoStackView)
        stackView.addArrangedSubview(carContainerView)
        
//        infoStackView.snp.makeConstraints {
//            $0.height.equalTo(14)
//        }
        
        infoStackView.addArrangedSubview(participantContainerView)
        infoStackView.addArrangedSubview(diamondsContainerView)
        infoStackView.addArrangedSubview(tipLabel)
        
        participantContainerView.addSubview(participantStackView)
        participantStackView.addArrangedSubview(personImageView)
        participantStackView.addArrangedSubview(participantsCountLabel)
        
        personImageView.snp.makeConstraints {
            $0.width.height.equalTo(12)
        }
        
        participantStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        diamondsContainerView.addSubview(diamondStackView)
        diamondStackView.addArrangedSubview(diamondsImageView)
        diamondStackView.addArrangedSubview(diamondsLabel)
        
        diamondsImageView.snp.makeConstraints {
            $0.width.height.equalTo(12)
        }
        
        diamondStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        carContainerView.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        carContainerView.addSubview(carImageView)
        containerView.addSubview(badgeView)
        badgeView.addSubview(statsLabel)
        
        carImageView.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.center.equalToSuperview()
        }
        
        statsLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().offset(-4)
            $0.top.equalToSuperview().offset(3)
            $0.bottom.equalToSuperview().offset(-3)
        }
        
        badgeView.snp.makeConstraints {
            $0.leading.equalTo(carImageView.snp.trailing)
            $0.top.equalTo(carImageView.snp.top)
        }
    }
    
    override func setupLocalization() {
        statsLabel.text = "2.4/5.2"
        ammountLabel.text = "202407091130"
        participantsCountLabel.text = "32,60,235"
        diamondsLabel.text = "32,60,235"
        
        
    }
 
    
    func render(with model: ChingariRaceSessionDetailsDTO, tips: Int?) {
        guard let winner = model.session.result?.winner else { return }
        
        carImageView.image = nil
        if let carImage = URL(string: winner.car.iconFrontThumb) {
            carImageView.sd_setImage(with: carImage)
        }
        
        statsLabel.text = "\(winner.dynamicOdds)/\(winner.car.standartOdds)"
        ammountLabel.text = model.session.sessionId
        participantsCountLabel.text = String(model.session.membersCount)
        diamondsLabel.text = String(model.session.totalBetsAmount)
        
        let attributedString = NSMutableAttributedString(string: "(Tip: ", attributes: [
            .font: CHFont(font: .poppinsRegular, style: .caption2).uiFont,
            .foregroundColor: UIColor(hexString: "#551C88")
        ])
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: CarRaceGameConstants.Images.diamond)
        attachment.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
        attributedString.append(NSAttributedString(attachment: attachment))
        
        let tipsInt = tips ?? 0
        attributedString.append(NSAttributedString(string: "\(tipsInt))", attributes: [
            .font: CHFont(font: .poppinsRegular, style: .caption2).uiFont,
            .foregroundColor: UIColor(hexString: "#551C88")
        ]))
        
        tipLabel.textAlignment = .center
        tipLabel.attributedText = attributedString
        
    }
    
}
