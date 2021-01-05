//
//  CreateItemExampleConfigurator.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import Foundation

struct CreateItemExampleConfigurator {

    static func configure(_ viewController: CreateItemExampleViewController) {
        let router = CreateItemExampleRouter()
        viewController.router = router
        router.viewController = viewController
    }
}
