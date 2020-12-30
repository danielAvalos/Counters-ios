//
//  MainPresenter.swift
//  Counters
//
//  Created by DESARROLLO on 30/12/20.
//

import UIKit

protocol MainPresentationLogic {
}

final class MainPresenter {
    weak var viewController: MainDisplayLogic?
}

// MARK: - MainPresentationLogic

extension MainPresenter: MainPresentationLogic {
}
