//
//  MainPresenter.swift
//  Counters
//
//  Created by DESARROLLO on 30/12/20.
//

import UIKit

protocol MainPresentationLogic {
    func presentResponse(_ response: MainResponse)
}

final class MainPresenter {
    weak var viewController: MainDisplayLogic?
}

// MARK: - MainPresentationLogic

extension MainPresenter: MainPresentationLogic {

    func presentResponse(_ response: MainResponse) {
        let viewModel: [MainViewModel] = response.counters.map { (counterModel) -> MainViewModel in
            MainViewModel(model: counterModel)
        }
        viewController?.displayCounters(viewModel)
    }
}
