//
//  WelcomeConfigurator.swift
//  Counters
//
//  Created by DESARROLLO on 30/12/20.
//

import Foundation

struct WelcomeConfigurator {

    static func configure(_ viewController: WelcomeViewController) {
        let router = WelcomeRouter()
        viewController.router = router
        router.viewController = viewController
    }
}
