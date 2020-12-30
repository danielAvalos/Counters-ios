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
        /*let service =    CategoryService()
        let interactor = HomeInteractor(service: service)
        let presenter = HomePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController*/
    }
}
