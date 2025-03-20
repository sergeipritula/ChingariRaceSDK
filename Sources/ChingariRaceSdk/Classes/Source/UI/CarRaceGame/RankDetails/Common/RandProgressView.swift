//
//  RandProgressView.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit

class RankProgressView: CHView {
    
    private let containerView = UIView()
    
    private let progressContainerView = UIView()
    
    private let progressImageView = UIImageView()
    
    private let progressLabel = UILabel()
    
    override func setupView() {
        containerView.customizer
            .set(cornerRadius: 10)
            .set(backgroundColor: UIColor(hexString: "#331C76").withAlphaComponent(0.3))
            .set(borderWidth: 2)
            .set(borderColor: .white)
        
//        containerView.addShadow(
//            with: UIColor(hexString: "#3E1A50").withAlphaComponent(0.08),
//            offset: .init(width: 0, height: 1),
//            shadowOpacity: 1,
//            shadowRadius: 6
//        )
        
        progressImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.progress))
            .set(contentMode: .scaleAspectFill)
            .set(cornerRadius: 8)
            .set(clipsToBounds: true)
        
        progressLabel.customizer
            .set(font: .init(font: .poppinsMedium, style: .caption2))
            .set(textColor: .white.withAlphaComponent(0.6))
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(progressContainerView)
        containerView.addSubview(progressLabel)
        
        progressContainerView.addSubview(progressImageView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        progressContainerView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(2)
            $0.top.equalToSuperview().offset(2)
            $0.bottom.equalToSuperview().offset(-2)
            $0.trailing.equalToSuperview().offset(-2)
        }
        
        progressImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0)
        }
        
        progressLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setupProgress(_ progress: CGFloat) {
        progressImageView.snp.remakeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(progress)
        }
    }
    
    func setupLabel(_ text: String) {
        progressLabel.text = text
    }
    
}
