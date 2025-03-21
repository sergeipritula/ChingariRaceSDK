//
//  RankDetailsViewController.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

class RankDetailsViewController: ViewController<RankDetailsViewModel> {
    
    private(set) var dismissPublisher = PublishSubject<Void>()
    
    private let containerView = UIView()
 
    private let backButton = UIButton()
    
    private let titleLabel = UILabel()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView.isPagingEnabled = false
        self.collectionView.scrollToItem(at: .init(row: self.viewModel.currentIndex),
                                         at: .centeredHorizontally,
                                         animated: false)
        self.collectionView.isPagingEnabled = true
        
        UIView.animate(withDuration: 0.1) {
            self.collectionView.alpha = 1.0
        }
    }
    
    override func setupView() {
        view.backgroundColor = .clear
        containerView.backgroundColor = .white
        
        containerView.customizer
            .set(cornerRadius: 22)
            .set(maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        
        backButton.setImage(UIImage(named: CarRaceGameConstants.Images.back, in: .module, compatibleWith: nil), for: .normal)
        backButton.contentHorizontalAlignment = .leading
        backButton.contentVerticalAlignment = .center
        
        titleLabel.customizer
            .set(font: .init(font: .poppinsBold, style: .callout))
            .set(textColor: UIColor(hexString: "#815EF2"))
            .set(textAlignment: .center)
            .set(numberOfLines: 0)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        collectionView.isPagingEnabled = true
        
        collectionView.contentInset = .init(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerCellClass(RankDetailsCell.self)
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        
        // TODO: - just for tests
        collectionView.dataSource = self
        collectionView.delegate = self
        
        titleLabel.text = viewModel.cellModels[viewModel.currentIndex].carName
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
    }
    
    override func setupInput(input: RankDetailsViewModel.Output) {
        disposeBag.insert([
            
        ])
    }
    
    override func setupOutput() {
        let input = RankDetailsViewModel.Input(
            backEvent: backButton.rx.tap.asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
    
}

//MARK: - PanModalPresentable

extension RankDetailsViewController: PanModalPresentable {
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

extension RankDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ofType: RankDetailsCell.self, at: indexPath)
        cell.render(with: viewModel.cellModels[indexPath.row])
        
        cell.leftButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.moveLeft()
                
                self.collectionView.isPagingEnabled = false
                self.collectionView.scrollToItem(at: .init(row: self.viewModel.currentIndex), at: .centeredHorizontally, animated: true)
                self.titleLabel.text = viewModel.cellModels[viewModel.currentIndex].carName
                self.collectionView.isPagingEnabled = true
            })
            .disposed(by: cell.disposeBag)
        
        cell.rightButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.moveRight()
                
                self.collectionView.isPagingEnabled = false
                self.collectionView.scrollToItem(at: .init(row: self.viewModel.currentIndex), at: .centeredHorizontally, animated: true)
                self.titleLabel.text = viewModel.cellModels[viewModel.currentIndex].carName
                self.collectionView.isPagingEnabled = true
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
    
}
    
extension RankDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 32
        let collectionViewSize = UIScreen.main.bounds.width - padding
        let width = collectionViewSize
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
