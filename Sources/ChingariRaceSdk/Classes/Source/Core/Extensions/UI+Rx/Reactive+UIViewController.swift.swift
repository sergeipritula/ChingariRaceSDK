//
// Reactive+UIViewController.swift
// Pods
//
//  Created by Vorko Dmitriy on 12.05.2021.
// Copyright © 2020.  All rights reserved.

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit

    import RxCocoa
    import RxSwift

    public extension Reactive where Base: UIViewController {
        /// Emits signals when removed from its parent
        var didRemoveFromParentViewController: ControlEvent<Void> {
            let event = didMoveToParentViewController
                .filter { $0 == nil }
                .map { _ in () }
            return ControlEvent(events: event)
        }

        var viewDidLoad: ControlEvent<Void> {
            let type = methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
            return ControlEvent(events: type)
        }

        var viewWillAppear: ControlEvent<Bool> {
            let type = methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
            return ControlEvent(events: type)
        }

        var viewDidAppear: ControlEvent<Bool> {
            let type = methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
            return ControlEvent(events: type)
        }

        var viewWillDisappear: ControlEvent<Bool> {
            let type = methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
            return ControlEvent(events: type)
        }

        var viewDidDisappear: ControlEvent<Bool> {
            let type = methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
            return ControlEvent(events: type)
        }

        var viewWillLayoutSubviews: ControlEvent<Void> {
            let type = methodInvoked(#selector(Base.viewWillLayoutSubviews)).map { _ in }
            return ControlEvent(events: type)
        }

        var viewDidLayoutSubviews: ControlEvent<Void> {
            let type = methodInvoked(#selector(Base.viewDidLayoutSubviews)).map { _ in }
            return ControlEvent(events: type)
        }

        var willMoveToParentViewController: ControlEvent<UIViewController?> {
            let type = methodInvoked(#selector(Base.willMove)).map { $0.first as? UIViewController }
            return ControlEvent(events: type)
        }

        var didMoveToParentViewController: ControlEvent<UIViewController?> {
            let type = methodInvoked(#selector(Base.didMove)).map { $0.first as? UIViewController }
            return ControlEvent(events: type)
        }

        var didReceiveMemoryWarning: ControlEvent<Void> {
            let type = methodInvoked(#selector(Base.didReceiveMemoryWarning)).map { _ in }
            return ControlEvent(events: type)
        }

        /// Rx observable, triggered when the ViewController
        /// appearance state changes (true if the View is being displayed, false otherwise)
        var isVisible: RxObservable<Bool> {
            let viewDidAppearObservable = base.rx.viewDidAppear.map { _ in true }
            let viewWillDisappearObservable = base.rx.viewWillDisappear.map { _ in false }
            return RxObservable<Bool>.merge(viewDidAppearObservable, viewWillDisappearObservable)
        }

        /// Rx observable, triggered when the ViewController is being dismissed
        var isDismissing: ControlEvent<Bool> {
            let type = sentMessage(#selector(Base.dismiss)).map { $0.first as? Bool ?? false }
            return ControlEvent(events: type)
        }
    }
#endif
