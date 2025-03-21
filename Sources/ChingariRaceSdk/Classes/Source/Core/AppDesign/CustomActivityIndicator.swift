//
//  CustomActivityIndicator.swift
//  chingari
//
//  Created by Тетяна Нєізвєстна on 25.11.2021.
//  Copyright © 2021 Nikola Milic. All rights reserved.
//

import UIKit
import Lottie

class CustomActivityIndicator: UIView {
    let bgView = UIView()
    let animatedView = LottieAnimationView(name: "red_loader", bundle: .module)
    let imageView = UIImageView()
    
    func setup(color: UIColor) {
        bgView.backgroundColor = color
        animatedView.animationSpeed = 2.0
        animatedView.loopMode = .loop
        imageView.image = UIImage(named: "room_avatar_placeholder", in: .module, compatibleWith: nil)
        bgView.isHidden = true
        imageView.isHidden = true
        self.isHidden = true
        
        self.addSubview(bgView)
        self.addSubview(animatedView)
        self.addSubview(imageView)
        
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(frame.width)
            make.height.equalTo(frame.height)
        }
        animatedView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
    }
    
    func startAnimating() {
        DispatchQueue.main.async {
            self.bgView.isHidden = false
            self.imageView.isHidden = false
            self.animatedView.play()
            self.isHidden = false
        }
    }
    
    func stopAnimating() {
        DispatchQueue.main.async {
            self.bgView.isHidden = true
            self.imageView.isHidden = true
            self.animatedView.stop()
            self.isHidden = true
        }
    }
    
    func set(isLoading: Bool) {
        if isLoading {
            startAnimating()
        } else {
            stopAnimating()
        }
    }
}
