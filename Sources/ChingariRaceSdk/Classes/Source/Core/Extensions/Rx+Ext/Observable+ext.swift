// swiftlint:disable:this file_name
//  Extensions
//
//  Created by Vorko Dmitriy on 12.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

public protocol OptionalType {
    associatedtype Wrapped

    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Wrapped? { return self }
}

public extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

public extension SharedSequenceConvertibleType where Element == Bool {
    func isTrue() -> SharedSequence<SharingStrategy, Bool> {
        return flatMap { isTrue in
            guard isTrue else {
                return SharedSequence<SharingStrategy, Bool>.empty()
            }
            return SharedSequence<SharingStrategy, Bool>.just(true)
        }
    }
}

public extension SharedSequenceConvertibleType where Element: OptionalType {
    // swiftlint:disable indentation_width
    /**
     Unwraps and filters out `nil` elements.
     - returns: `SharedSequence` of source `SharedSequence`'s elements, with `nil` elements filtered out.
     */
    // swiftlint:enable indentation_width
    func ignoreNil() -> SharedSequence<SharingStrategy, Element.Wrapped> {
        return flatMap { value in
            value.optional.map {
                SharedSequence<SharingStrategy, Element.Wrapped>
                    .just($0)
            } ?? SharedSequence<SharingStrategy, Element.Wrapped>.empty()
        }
    }
}

public extension ObservableType {
    func catchErrorJustComplete() -> RxObservable<Element> {
        return self.catch { _ in
            RxObservable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            Driver.empty()
        }
    }

    func mapToVoid() -> RxObservable<Void> {
        return map { _ in }
    }
}

public extension ObservableType where Element: OptionalType {
    func ignoreNil() -> RxObservable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { RxObservable.just($0) } ?? RxObservable.empty()
        }
    }
}

public extension ObservableType where Element: Collection {
    /// Ignores empty arrays
    func ignoreEmpty() -> RxObservable<Element> {
        return flatMap { array in
            array.isEmpty ? RxObservable.empty() : RxObservable.just(array)
        }
    }
}

public extension ObservableType {
    func asOptional() -> RxObservable<Element?> {
        map { element -> Element? in
            element
        }
    }
}

public extension BehaviorRelay {
    func makeSignal() {
        accept(value)
    }
}
