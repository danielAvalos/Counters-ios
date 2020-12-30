//
//  WelcomeRouter.swift
//  Counters
//
//  Created by DESARROLLO on 30/12/20.
//

import UIKit

protocol WelcomeRoutingLogic {
    func navigateToMain()
}

// MARK: - HomeRoutingLogic

final class WelcomeRouter: NSObject, WelcomeRoutingLogic {

    weak var viewController: WelcomeViewController?

    func navigateToMain() {
        guard let controller = MainViewController.instantiate() as? MainViewController else {
            return
        }
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        viewController?.present(navigationController,
                                animated: true,
                                completion: nil)
    }
}
