//
//  DiamondConfirmView.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DiamondsConfirmView: CHView {
    
    private var disposeBag = DisposeBag()
    
    private let containerView = UIView()
    
    private let dismissButton = UIButton()
    
    private let titleLabel = UILabel()
    
    private let confirmButton = CHGradientButton(
        model: .init(gradientColor: .primary, direction: .leftToRight),
        cornerRadius: 28
    )
    
    private let closeButton = UIButton()
    
    // INPUT
    let currentBetRelay: BehaviorRelay<Int?> = .init(value: nil)
    
    // OUTPUT
    private let closeSubject: PublishSubject<Void> = .init()
    var closeEvent: RxObservable<Void> { closeSubject }
    
    private let confirmSubject: PublishSubject<Void> = .init()
    var confirmEvent: RxObservable<Void> { confirmSubject }
    
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
        
        containerView.customizer
            .set(backgroundColor: .white)
            .set(cornerRadius: 12)
        
        titleLabel.customizer
            .set(font: .init(font: .poppinsSemiBold, style: .headline))
            .set(textColor: .black)
            .set(textAlignment: .center)
            .set(numberOfLines: 0)
        
        confirmButton.customizer
            .set(font: .init(font: .poppinsSemiBold, style: .callout))
            .set(normalTitleColor: .white)
        
        closeButton.customizer
            .set(image: UIImage(named: "close_gray", in: .module, compatibleWith: nil))
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubviews([dismissButton, titleLabel, confirmButton, closeButton])
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(30)
            $0.leading.equalTo(containerView.snp.leading).offset(16)
            $0.trailing.equalTo(containerView.snp.trailing).offset(-16)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalTo(containerView.snp.leading).offset(40)
            $0.trailing.equalTo(containerView.snp.trailing).offset(-40)
            $0.bottom.equalTo(containerView.snp.bottom).offset(-40)
            $0.height.equalTo(56)
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(2)
            $0.trailing.equalTo(containerView.snp.trailing).offset(-2)
            $0.width.height.equalTo(16)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(12)
            $0.trailing.equalTo(containerView.snp.trailing).offset(-12)
            $0.width.height.equalTo(32)
        }
    }
    
    override func setupLocalization() {
//        confirmButton.setTitle(Localizationable.RaceGame.confirm.localized, for: .normal)
        confirmButton.setTitle("Confirm", for: .normal)
    }
    
    private func setupBindings() {
        disposeBag.insert(
            setupCloseButtonBindings(),
            setupConfirmButtonBindings(),
            setupDiamondsAmountObserving()
        )
    }
    
    private func setupConfirmButtonBindings() -> Disposable {
        confirmButton.rx.tap.asObservable().bind(to: confirmSubject)
    }
    
    private func setupCloseButtonBindings() -> Disposable {
        closeButton.rx.tap.asObservable().bind(to: closeSubject)
    }
    
    private func setupDiamondsAmountObserving() -> Disposable {
        currentBetRelay.asObservable()
            .subscribe(onNext: { [weak self] value in
                let diamondsString = NSMutableAttributedString(string: "Are you sure to spend?\n", attributes: [
                    .foregroundColor: UIColor.black,
                    .font: CHFont.init(font: .poppinsBold, style: .title3).uiFont
                ])
                
                let amountString = NSMutableAttributedString(string: "\(value ?? 0) ", attributes: [
                    .foregroundColor: UIColor.black,
                    .font: CHFont.init(font: .poppinsBold, style: .title3).uiFont
                ])
                
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "ic_game_diamond", in: .module, compatibleWith: nil)
                attachment.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
                
                amountString.append(NSAttributedString(attachment: attachment))
                
                diamondsString.append(amountString)
                self?.titleLabel.attributedText = diamondsString
            })
    }
    
}
