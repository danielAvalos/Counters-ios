//
//  MainPresenter.swift
//  Counters(
//
//  Created by DESARROLLO on 30/12/20.
//

import UIKit

protocol MainPresentationLogic {
    func presentError(_ response: ErrorModel)
    func presentMessage(_ response: MessageModel)
    func presentToast(_ response: MessageModel)
    func presentCounterListResponse(_ response: MainResponse)
    func presentTextToShareResponse(_ response: String)
}

final class MainPresenter {
    weak var viewController: MainDisplayLogic?
}

// MARK: - MainPresentationLogic

extension MainPresenter: MainPresentationLogic {
    func presentToast(_ response: MessageModel) {
        viewController?.displayToast(model: response)
    }

    func presentMessage(_ response: MessageModel) {
        viewController?.displayMessage(model: response)
    }

    func presentError(_ response: ErrorModel) {
        viewController?.displayError(model: response)
    }

    func presentTextToShareResponse(_ response: String) {
        viewController?.displayCountersShare(response)
    }

    func presentCounterListResponse(_ response: MainResponse) {
        guard !response.counters.isEmpty else {
            let messageModel = MessageModel(title: "No counters yet",
                                            description: "When I started counting my blessings, my whole life turned around. \n —Willie Nelson",
                                            action: .newCounter)
            viewController?.displayMessage(model: messageModel)
            return
        }
        let viewModel: [MainViewModel] = response.counters.map { (counterModel) -> MainViewModel in
            MainViewModel(model: counterModel)
        }
        viewController?.displayCounters(viewModel, message: response.messageItemSelected)
    }
}
