//
//  UIViewController+Alerts.swift
//  Counters
//
//  Created by DESARROLLO on 30/12/20.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, customActionTitle: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        guard presentedViewController == nil else {
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: customActionTitle ?? "OK",
            style: .default,
            handler: handler
        )
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}