//
//  MainPresenter.swift
//  Counters
//
//  Created by DESARROLLO on 30/12/20.
//

import UIKit

protocol MainPresentationLogic {
    func presentCounterListResponse(_ response: MainResponse)
    func presentTextToShareResponse(_ response: String)
}

final class MainPresenter {
    weak var viewController: MainDisplayLogic?
}

// MARK: - MainPresentationLogic

extension MainPresenter: MainPresentationLogic {

    func presentTextToShareResponse(_ response: String) {
        viewController?.displayCountersShare(response)
    }

    func presentCounterListResponse(_ response: MainResponse) {
        let viewModel: [MainViewModel] = response.counters.map { (counterModel) -> MainViewModel in
            MainViewModel(model: counterModel)
        }
        viewController?.displayCounters(viewModel, message: response.messageItemSelected)
    }
}
