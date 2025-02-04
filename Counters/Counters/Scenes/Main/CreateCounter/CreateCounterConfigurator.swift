//
//  CreateCounterConfigurator.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import Foundation

struct CreateCounterConfigurator {

    static func configure(_ viewController: CreateCounterViewController) {
        let service = CountersService()
        let interactor = CreateCounterInteractor(service: service)
        let presenter = CreateCounterPresenter()
        let router = CreateCounterRouter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        viewController.router = router
        router.viewController = viewController
        presenter.viewController = viewController
    }
}
