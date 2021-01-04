//
//  MainPresenter.swift
//  Counters(
//
//  Created by DESARROLLO on 30/12/20.
//

import UIKit

protocol MainPresentationLogic {
    func presentError(_ response: ErrorModel)
    func presentCounterListResponse(_ response: MainResponse)
    func presentTextToShareResponse(_ response: String)
    func presentCounterUpdatedResponse(_ response: MainResponse)
}

final class MainPresenter {
    weak var viewController: MainDisplayLogic?
}

// MARK: - MainPresentationLogic

extension MainPresenter: MainPresentationLogic {

    func presentCounterUpdatedResponse(_ response: MainResponse) {
    }

    func presentError(_ response: ErrorModel) {
    }

    func presentTextToShareResponse(_ response: String) {
        viewController?.displayCountersShare(response)
    }

    func presentCounterListResponse(_ response: MainResponse) {
        guard !response.counters.isEmpty else {
            let messageModel = MessageModel(title: "No counters yet",
                                            description: "When I started counting my blessings, my whole life turned around. \n —Willie Nelson",
                                            titleAction: "Create a counter")
            viewController?.displayEmptyCounterMessage(model: messageModel)
            return
        }
        let viewModel: [MainViewModel] = response.counters.map { (counterModel) -> MainViewModel in
            MainViewModel(model: counterModel)
        }
        viewController?.displayCounters(viewModel, message: response.messageItemSelected)
    }
}
