//
//  RaceHistoryDetailsViewController.swift
//  chingari
//
//  Created by Sergey Pritula on 26.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

class RaceHistoryDetailsViewController: ViewController<RaceHistoryDetailsViewModel> {
    
    private(set) var dismissPublisher = PublishSubject<Void>()
    
    private let containerView = UIView()
    
    private let titleLabel = UILabel()
    
    private let backButton = UIButton()
    
    private let statsView = RaceHistoryStatsView()
    
    private let header = RaceHistoryDetailsHeaderView()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let footerView = RaceHistoryDetailsFooterView()
    
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
        
        tableView.registerCellClass(RaceHistoryDetailsCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentOffset = .zero
        tableView.contentInset = .init(top: 0, left: 0, bottom: 50, right: 0)
        
        header.roundCornersMask(corners: [.topLeft, .topRight], radius: 12)
        
//        addCenterActivityView(activityIndicator)
        
        footerView.isHidden = true
        statsView.isHidden = true
    }
    
    override func setupConstraints() {
        view.addSubview(containerView)
        
        containerView.addSubviews([header, statsView, tableView, titleLabel, footerView, backButton])
        
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
        
        statsView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(108)
        }
        
        header.snp.makeConstraints {
            $0.top.equalTo(statsView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
        
        footerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }

    }
    
    override func setupLocalization() {
//        titleLabel.text = Localizationable.RaceGame.historyDetails.localized
    }
    
    override func setupInput(input: RaceHistoryDetailsViewModel.Output) {
        disposeBag.insert([
            setupActivityIndicatorSignalObserving(with: input.loading),
            setupItemsObserving(with: input.items),
            setupMyWinnerObserving(with: input.winner),
            setupSessionObserving(with: input.session)
        ])
    }
    
    override func setupOutput() {
        let input = RaceHistoryDetailsViewModel.Input(
            backEvent: backButton.rx.tap.asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
    
    private func setupActivityIndicatorSignalObserving(with signal: Driver<Bool>) -> Disposable {
        signal.drive(with: self, onNext: {`self`, isLoading in
            isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        })
    }
    
    private func setupItemsObserving(with signal: RxObservable<[RaceHistoryDetailsCellViewModel]>) -> Disposable {
        signal
            .asDriverOnErrorJustComplete()
            .do(onNext: { [weak self] items in self?.header.isHidden = items.isEmpty })
            .drive(tableView.rx.items) { tableView, row, model -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(ofType: RaceHistoryDetailsCell.self, at: IndexPath(row: row))
                cell.render(with: model, index: row)
                return cell
            }
    }
    
    private func setupMyWinnerObserving(with signal: RxObservable<ChingariRaceSesssionLeaderboardDTO?>) -> Disposable {
        signal
            .subscribe(onNext: { [weak self] winner in
                self?.footerView.isHidden = winner == nil
                self?.footerView.render(with: winner)
            })
    }
    
    private func setupSessionObserving(with signal: RxObservable<ChingariRaceSessionDetailsDTO>) -> Disposable {
        signal
            .subscribe(onNext: { [weak self] session in
                self?.header.render(
                    winners: String(session.winnersCount),
                    carName: session.session.result?.winner.car.name ?? ""
                )
                self?.statsView.isHidden = false
                self?.statsView.render(with: session, tips: session.tips)
            })
    }
    
}


//MARK: - PanModalPresentable

extension RaceHistoryDetailsViewController: PanModalPresentable {
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

