//
//  CreateCounterRouter.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import Foundation

protocol CreateCounterRoutingLogic {
    func navigatePopViewController()
    func navigateToShowExample()
}

// MARK: - MainRoutingLogic

final class CreateCounterRouter: NSObject, CreateCounterRoutingLogic {

    weak var viewController: CreateCounterViewController?

    func  navigatePopViewController() {
        guard let navigationController = viewController?.navigationController else {
            return
        }
        navigationController.popViewController(animated: true)
    }

    func  navigateToShowExample() {
        guard let navigationController = viewController?.navigationController,
              let controller = CreateItemExampleViewController.instantiate() as? CreateItemExampleViewController else {
            return
        }
        navigationController.pushViewController(controller, animated: true)
    }
}
