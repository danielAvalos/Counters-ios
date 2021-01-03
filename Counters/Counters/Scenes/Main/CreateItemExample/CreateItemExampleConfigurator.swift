//
//  CreateItemExampleConfigurator.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import Foundation

struct CreateItemExampleConfigurator {

    static func configure(_ viewController: CreateItemExampleViewController) {
        //let service = CounterService()
        //let interactor = CreateCounterInteractor()
        //let presenter = CreateCounterPresenter()
        let router = CreateItemExampleRouter()
        //viewController.interactor = interactor
        //interactor.presenter = presenter
        viewController.router = router
        router.viewController = viewController
        //presenter.viewController = viewController
    }
}
