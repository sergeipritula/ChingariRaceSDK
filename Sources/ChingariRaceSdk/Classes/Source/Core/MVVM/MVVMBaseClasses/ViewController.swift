//
//  ViewController.swift
//  MVVM
//
//  Created by Vorko Dmitriy on 12.05.2021.
//

import Foundation
import UIKit
import RxSwift

fileprivate enum AssociatedKeys {
    static var disposeBag = "ViewController dispose bag associated key"
}

extension ViewController {

    public fileprivate(set) var disposeBag: DisposeBag {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            if let bag = objc_getAssociatedObject(self, &AssociatedKeys.disposeBag) as? DisposeBag {
                return bag
            } else {
                let bag = DisposeBag()
                objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, bag, .OBJC_ASSOCIATION_RETAIN)
                return bag
            }
        }
    }
}


open class ViewController<ViewModel: ViewModelProtocol>: UIViewController,
                                                         ViewProtocol,
                                                         DeinitAnnouncerType,
                                                         Accessible

{
    // swiftlint:disable:next implicitly_unwrapped_optional
    public var viewModel: ViewModel!
    private let deinitSubject = PublishSubject<Void>()
    public var deinitObservable: RxObservable<Void> { deinitSubject }
    
    // MARK: - Constructor

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupDeinitAnnouncer()
    }

    public init(viewModel: ViewModel,
                nibName: String? = nil,
                bundle: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: bundle)
        setupDeinitAnnouncer()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDeinitAnnouncer()
    }
    
    deinit {
        deinitSubject.onNext(())
    }

    // MARK: - Life Cycle

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupView()
        setupScrollCollection()
        setupNavigationBar()
        setupLocalization()
        setupOutput()
        generateAccessibilityIdentifiers()
    }

    // MARK: - Setup Functions

    /// override to setup constraints. Called in viewDidLoad method.
    open func setupConstraints() {}

    /// override to setup views. Called in viewDidLoad method.
    open func setupView() {}

    /// override to setup localization. Called in viewDidLoad method.
    open func setupLocalization() {}

    /// override to setup collection such as UITableView, UICollectionView or etc. Called in viewDidLoad method.
    open func setupScrollCollection() {}

    /// override to setup view navigation bar appereance. Called in viewDidLoad method.
    open func setupNavigationBar() {}

    // MARK: - ViewProtocol

    open func setupOutput() {}

    open func setupInput(input: ViewModel.Output) {}
}
