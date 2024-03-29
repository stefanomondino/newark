//
//  RxListViewModel.swift
//  RxBoomerang
//
//  Created by Stefano Mondino on 01/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
#if !COCOAPODS
import Boomerang
#endif

public protocol RxViewModel: ViewModel {
    var disposeBag: DisposeBag { get }
}

public protocol RxNavigationViewModel: NavigationViewModel {
    var routes: PublishRelay<Route> { get }
}

extension RxNavigationViewModel {
    public var onNavigation: (Route) -> Void {
        get { return {[weak self] in self?.routes.accept($0)} }
        set { }
    }
}

public protocol RxListViewModel: ListViewModel, RxViewModel {
    var sectionsRelay: BehaviorRelay<[Section]> { get }
}

public extension RxListViewModel {
    var sections: [Section] {
        get {
            sectionsRelay.value
        }
        set {
            sectionsRelay.accept(newValue)
        }
    }
    var onUpdate: () -> Void {
        get { return {} }
        set { }
//        return {[weak self] in self?.sectionsRelay.accept(self?.sections ?? []) }
    }
}

public extension Reactive where Base: RxListViewModel {
    var sections: Observable<[Section]> {
        return base.sectionsRelay.asObservable()
    }
}

extension Section: IdentifiableType {
    public var identity: String {
        return self.id
    }
}

struct IdentifiableViewModel: IdentifiableType, Equatable {
    static func == (lhs: IdentifiableViewModel, rhs: IdentifiableViewModel) -> Bool {
        lhs.identity == rhs.identity
    }

    var viewModel: ViewModel
    var identity: String {
        return viewModel.uniqueIdentifier.stringValue
    }
}
