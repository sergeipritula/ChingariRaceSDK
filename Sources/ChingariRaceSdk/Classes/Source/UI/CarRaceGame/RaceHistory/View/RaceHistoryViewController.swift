//
//  RaceHistoryViewController.swift
//  chingari
//
//  Created by Sergey Pritula on 26.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

class RaceHistoryViewController: ViewController<RaceHistoryViewModel> {
    
    private(set) var dismissPublisher = PublishSubject<Void>()
    
    private let containerView = UIView()
    
    private let backButton = UIButton()
    
    private let tableView = UITableView()
    
    private let actionsStackView = UIStackView()
    
    private let leftButton = UIButton()
    
    private let rightButton = UIButton()
    
    private let indicatorView = CHGradientView(
        model: .init(gradientColor: .primary),
        cornerRadius: 1
    )
    
    private let refreshControl = UIRefreshControl()
    
    private let header = RaceHistoryHeaderView()
    
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
        
        actionsStackView.customizer
            .set(distribution: .fillEqually)
            .set(axis: .horizontal)
        
        leftButton.customizer
            .set(font: .init(font: .poppinsSemiBold, style: .callout))
            .set(normalTitleColor: UIColor(hexString: "#815EF2"))
        
        rightButton.customizer
            .set(font: .init(font: .poppinsMedium, style: .callout))
            .set(normalTitleColor: UIColor(hexString: "#877B93"))
        
        tableView.registerCellClass(RaceHistoryCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        tableView.refreshControl = refreshControl
        
        header.roundCornersMask(corners: [.topLeft, .topRight], radius: 12)
    }
    
    override func setupConstraints() {
        view.addSubview(containerView)
        
        containerView.addSubviews([header, tableView, actionsStackView, indicatorView, backButton])
        
        actionsStackView.addArrangedSubview(leftButton)
        actionsStackView.addArrangedSubview(rightButton)
        
        containerView.snp.makeConstraints {
            $0.height.equalTo(470)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(32)
        }
        
        actionsStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        indicatorView.snp.makeConstraints {
            $0.top.equalTo(actionsStackView.snp.bottom)
            $0.centerX.equalTo(leftButton.snp.centerX)
            $0.width.equalTo(22)
            $0.height.equalTo(2)
        }
        
        header.snp.makeConstraints {
            $0.top.equalTo(leftButton.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
        
        addCenterActivityView(activityIndicator)
    }
    
    override func setupLocalization() {
//        leftButton.setTitle(Localizationable.RaceGame.history.localized, for: .normal)
//        rightButton.setTitle(Localizationable.RaceGame.my.localized, for: .normal)
        leftButton.setTitle("History", for: .normal)
        rightButton.setTitle("My", for: .normal)
    }
    
    override func setupInput(input: RaceHistoryViewModel.Output) {
        disposeBag.insert([
            setupItemsObserving(with: input.itemsEvent),
            setupLeftButtonSelected(),
            setupRightButtonSelected(),
            setupActivityIndicatorSignalObserving(with: input.loadingEvent)
        ])
    }
    
    override func setupOutput() {
        let ownHistoryTypeEvent = leftButton.rx.tap.map { HistoryRaceType.all }
        let myHistoryEvent = rightButton.rx.tap.map { HistoryRaceType.my }
        
        let historyTypeEvent = Observable.merge(myHistoryEvent, ownHistoryTypeEvent)
        
        let input = RaceHistoryViewModel.Input(
            backEvent: backButton.rx.tap.asObservable(),
            historyTypeEvent: historyTypeEvent,
            modelSelected: tableView.rx.modelSelected(RaceHistoryCellViewModel.self).asObservable(),
            loadMoreEvent: tableView.rx.nearBottom(edgeOffset: 50).asObservable(),
            refreshEvent: refreshControl.rx.controlEvent(.valueChanged).asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
    
    private func setupItemsObserving(with signal: RxObservable<[RaceHistoryCellViewModel]>) -> Disposable {
        signal
            .asDriverOnErrorJustComplete()
            .do(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            })
            .drive(tableView.rx.items) { tableView, row, model -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(
                    ofType: RaceHistoryCell.self,
                    at: IndexPath(row: row)
                )
                cell.render(index: row, viewModel: model)
                return cell
            }
    }
    
    private func setupActivityIndicatorSignalObserving(with signal: Driver<Bool>) -> Disposable {
        signal.drive(with: self, onNext: {`self`, isLoading in
            isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        })
    }
    
    private func setupLeftButtonSelected() -> Disposable {
        leftButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.indicatorView.snp.remakeConstraints {
                    $0.top.equalTo(owner.actionsStackView.snp.bottom)
                    $0.centerX.equalTo(owner.leftButton.snp.centerX)
                    $0.width.equalTo(22)
                    $0.height.equalTo(2)
                }
                owner.header.render(isOwn: false)
                
                owner.leftButton.customizer
                    .set(font: .init(font: .poppinsSemiBold, style: .callout))
                    .set(normalTitleColor: UIColor(hexString: "#815EF2"))
                
                owner.rightButton.customizer
                    .set(font: .init(font: .poppinsMedium, style: .callout))
                    .set(normalTitleColor: UIColor(hexString: "#877B93"))
            })
    }
    
    private func setupRightButtonSelected() -> Disposable {
        rightButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.indicatorView.snp.remakeConstraints {
                    $0.top.equalTo(owner.actionsStackView.snp.bottom)
                    $0.centerX.equalTo(owner.rightButton.snp.centerX)
                    $0.width.equalTo(22)
                    $0.height.equalTo(2)
                }
                owner.header.render(isOwn: true)
                
                owner.rightButton.customizer
                    .set(font: .init(font: .poppinsSemiBold, style: .callout))
                    .set(normalTitleColor: UIColor(hexString: "#815EF2"))
                
                owner.leftButton.customizer
                    .set(font: .init(font: .poppinsMedium, style: .callout))
                    .set(normalTitleColor: UIColor(hexString: "#877B93"))
            })
    }
}


//MARK: - PanModalPresentable

extension RaceHistoryViewController: PanModalPresentable {
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

