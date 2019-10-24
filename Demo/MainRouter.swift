//
//  MainRouter.swift
//  Demo
//
//  Created by Stefano Mondino on 24/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import UIKit

class MainRouter: Router {
    private let factory: ViewControllerFactory
    init(factory: ViewControllerFactory = MainViewControllerFactory()) {
        self.factory = factory
    }
    public func execute(_ route: Route, from source: Scene?) {
        switch route {
            case let route as NavigationRoute:
                if let viewController = factory.viewController(from: route.viewModel.itemIdentifier) as? UIViewController & WithItemViewModel,
                    let source = source
                    {
                    viewController.configure(with: route.viewModel)
                    if let navigation = source.navigationController {
                        self.push(viewController: viewController, from: navigation)
                    } else {
                        self.present(viewController: viewController, from: source)
                    }
            }
                
                
            default: break
        }
    }
    
    private func push(viewController: UIViewController, from navigationController: UINavigationController) {
        navigationController.pushViewController(viewController, animated: true)
    }
    private func present(viewController: UIViewController, from source: UIViewController, animated: Bool = true) {
        source.present(viewController, animated: animated, completion: nil)
    }
    func restart() {
        let viewModel = ScheduleViewModel()
        let root = factory.viewController(from: viewModel.itemIdentifier)
        (root as? WithItemViewModel)?.configure(with: viewModel)
        //TODO Dismiss all modals
        UIApplication.shared.delegate?.window??.rootViewController = root
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }
}
