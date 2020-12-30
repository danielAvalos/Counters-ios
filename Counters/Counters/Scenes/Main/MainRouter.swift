//
//  MainRouter.swift
//  Counters
//
//  Created by DESARROLLO on 30/12/20.
//

import Foundation

protocol MainRoutingLogic {
    func navigateToNewCounter()
}

// MARK: - MainRoutingLogic

final class MainRouter: NSObject, MainRoutingLogic {

    weak var viewController: MainViewController?

    func  navigateToNewCounter() {
        guard let navigationController = viewController?.navigationController,
              let controller = CreateCounterViewController.instantiate() as? CreateCounterViewController else {
            return
        }
        navigationController.pushViewController(controller, animated: true)
    }
}
