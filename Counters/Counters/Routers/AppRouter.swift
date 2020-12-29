//
//  AppRouter.swift
//  Counters
//
//  Created by DESARROLLO on 29/12/20.
//

import UIKit

class AppRouter {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        window.makeKeyAndVisible()
    }
}
