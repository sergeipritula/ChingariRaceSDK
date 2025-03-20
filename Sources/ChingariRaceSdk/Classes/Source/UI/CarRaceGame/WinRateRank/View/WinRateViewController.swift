//
//  WinRateViewController.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

class WinRateViewController: ViewController<WinRateViewModel> {
    
    private(set) var dismissPublisher = PublishSubject<Void>()
    
    private(set) var didSelectPublisher = PublishSubject<Void>()
    
    private let containerView = UIView()
    
    private let backButton = UIButton()
    
    private let titleLabel = UILabel()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func setupView() {
        view.backgroundColor = .clear
        containerView.backgroundColor = .white
        
        containerView.customizer
            .set(cornerRadius: 22)
            .set(maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        
        backButton.setImage(UIImage(named: CarRaceGameConstants.Images.back), for: .normal)
        backButton.contentHorizontalAlignment = .leading
        backButton.contentVerticalAlignment = .center
        
        titleLabel.customizer
            .set(font: .init(font: .poppinsBold, style: .callout))
            .set(textColor: UIColor(hexString: "#815EF2"))
            .set(textAlignment: .center)
            .set(numberOfLines: 0)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.contentInset = .init(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerCellClass(WinRateRankCell.self)
    }
    
    override func setupConstraints() {
        view.addSubview(containerView)
        
        containerView.addSubviews([backButton, titleLabel, collectionView])
        
        containerView.snp.makeConstraints {
            $0.height.equalTo(470)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16) // Add inset to ensure proper layout
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        addCenterActivityView(activityIndicator)
    }
    
    override func setupLocalization() {
//        titleLabel.text = Localizationable.RaceGame.winRank.localized
        titleLabel.text = "Win Rate"
    }
    
    override func setupInput(input: WinRateViewModel.Output) {
        disposeBag.insert([
            setupItemsObserving(with: input.items),
            setupDelegateObserving(),
            setupLoadingObserving(with: input.loading)
        ])
    }
    
    override func setupOutput() {
        let input = WinRateViewModel.Input(
            backEvent: backButton.rx.tap.asObservable(),
            didSelect: collectionView.rx.modelSelected(WinRateRankCellViewModel.self).asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
    
    private func setupItemsObserving(with signal: RxObservable<[WinRateRankCellViewModel]>) -> Disposable {
        signal
            .asDriverOnErrorJustComplete()
            .drive(collectionView.rx.items) { collectionView, row, model -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(
                    ofType: WinRateRankCell.self,
                    at: IndexPath(row: row)
                )
                cell.render(with: model)
                return cell
            }
    }
    
    private func setupDelegateObserving() -> Disposable {
        collectionView.rx.setDelegate(self)
    }
    
    private func setupLoadingObserving(with signal: RxObservable<Bool>) -> Disposable {
        signal
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] isLoading in
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            })
    }
}

//MARK: - PanModalPresentable

extension WinRateViewController: PanModalPresentable {
    var longFormHeight: PanModalHeight {
        return .contentHeight(470)
    }
    
    var showDragIndicator: Bool { false }
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    func panModalDidDismiss() {
        dismissPublisher.onNext(())
    }
}
    
extension WinRateViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 32
        let spacing: CGFloat = 20
        let itemsPerRow: CGFloat = 3
        
        let totalSpacing = padding + spacing * (itemsPerRow - 1)
        let collectionViewWidth = UIScreen.main.bounds.width - totalSpacing
        let itemWidth = collectionViewWidth / itemsPerRow
        let coeficient: CGFloat = 1.15
        
        return CGSize(width: itemWidth, height: itemWidth * coeficient)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
