//
//  SpeedRankViewController.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

class SpeedRankViewController: ViewController<SpeedRankViewModel> {
    
    private(set) var dismissPublisher = PublishSubject<Void>()
    
    private let containerView = UIView()
    
    private let backButton = UIButton()
    
    private let titleLabel = UILabel()
    
    private let roadTypeImageView = UIImageView()
    
    private let roadTypeLabel = UILabel()
    
    private let arrowRoadImageView = UIImageView()
    
    private let tableView = UITableView()
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func setupView() {
        view.backgroundColor = .clear
        containerView.backgroundColor = .white
        
        containerView.customizer
            .set(cornerRadius: 22)
            .set(maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        
        backButton.setImage(UIImage(named: CarRaceGameConstants.Images.back), for: .normal)
        backButton.contentHorizontalAlignment = .leading
        backButton.contentVerticalAlignment = .top
        
        titleLabel.customizer
            .set(font: .init(font: .poppinsBold, style: .callout))
            .set(textColor: UIColor(hexString: CarRaceGameConstants.Colors.purple))
            .set(textAlignment: .center)
            .set(numberOfLines: 0)
        
        arrowRoadImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.raceArrowLong))
            .set(contentMode: .scaleToFill)
        
        roadTypeImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.roadFaded))
            .set(contentMode: .scaleToFill)
        
        roadTypeLabel.customizer
            .set(font: .init(font: .poppinsBold, style: .caption1))
            .set(textColor: .white)
        
        tableView.registerCellClass(SpeedRankCell.self)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func setupConstraints() {
        view.addSubview(containerView)
        
        containerView.addSubviews([
            tableView, backButton, titleLabel, arrowRoadImageView, roadTypeImageView
        ])
        
        arrowRoadImageView.addSubview(roadTypeLabel)
        
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
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        arrowRoadImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(26)
        }
        
        roadTypeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-4)
        }
        
        roadTypeImageView.snp.makeConstraints {
            $0.top.equalTo(arrowRoadImageView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(35)
            $0.width.equalTo(150)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(roadTypeImageView.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        addCenterActivityView(activityIndicator)
    }
    
    override func setupLocalization() {
//        titleLabel.text = Localizationable.RaceGame.speedRank.localized
        titleLabel.text = "Speed Rank"
    }
    
    override func setupInput(input: SpeedRankViewModel.Output) {
        disposeBag.insert([
            setupRoadObserving(with: input.road),
            setupItemsObserving(with: input.items),
            setupLoadingObserving(with: input.loading)
        ])
    }
    
    override func setupOutput() {
        let input = SpeedRankViewModel.Input(
            backEvent: backButton.rx.tap.asObservable(),
            itemSelected: tableView.rx.modelSelected(SpeedRankCellViewModel.self).asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
    
    private func setupLoadingObserving(with signal: Driver<Bool>) -> Disposable {
        signal.drive(with: self, onNext: {`self`, isLoading in
            isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        })
    }
    
    private func setupRoadObserving(with signal: RxObservable<Road>) -> Disposable {
        signal
            .subscribe(onNext: { [weak self] road in
                self?.roadTypeLabel.text = road.roadType.prepareRoadTitle
                self?.roadTypeImageView.image = road.roadType.imageFaded
            })
    }
    
    private func setupItemsObserving(with signal: RxObservable<[SpeedRankCellViewModel]>) -> Disposable {
        signal
            .asDriverOnErrorJustComplete()
            .drive(tableView.rx.items) { tableView, row, viewModel in
                let cell = tableView.dequeueReusableCell(
                    ofType: SpeedRankCell.self,
                    at: .init(row: row, section: .zero)
                )
                cell.render(with: viewModel)
                return cell
            }
    }

}

//MARK: - PanModalPresentable

extension SpeedRankViewController: PanModalPresentable {
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
