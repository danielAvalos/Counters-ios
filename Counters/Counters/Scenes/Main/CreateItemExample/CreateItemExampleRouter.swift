//
//  CreateItemExampleRouter.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import Foundation

protocol CreateItemExampleRoutingLogic {
    func navigatePopViewController()
}

// MARK: - CreateItemExampleRoutingLogic

final class CreateItemExampleRouter: NSObject, CreateItemExampleRoutingLogic {

    weak var viewController: CreateItemExampleViewController?

    func  navigatePopViewController() {
        guard let navigationController = viewController?.navigationController else {
            return
        }
        navigationController.popViewController(animated: true)
    }
}
