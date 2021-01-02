//
//  MainConfigurator.swift
//  Counters
//
//  Created by DESARROLLO on 30/12/20.
//

import Foundation

struct MainConfigurator {

    static func configure(_ viewController: MainViewController) {
        //let service =    CategoryService()
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        viewController.router = router
        router.viewController = viewController
        presenter.viewController = viewController
    }
}
