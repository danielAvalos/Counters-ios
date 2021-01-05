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
            title: customActionTitle ?? "Continue",
            style: .default,
            handler: handler
        )
        okAction.setValue(UIColor.color(named: .orange),
                          forKey: "titleTextColor")
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    func showToast(message: String) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.color(named: .orange)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25
        toastContainer.clipsToBounds  =  true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.color(named: .white)
        toastLabel.textAlignment = .center
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        self.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let label1 = NSLayoutConstraint(item: toastLabel,
                                    attribute: .leading,
                                    relatedBy: .equal,
                                    toItem: toastContainer,
                                    attribute: .leading,
                                    multiplier: 1, constant: 15)
        let label2 = NSLayoutConstraint(item: toastLabel,
                                    attribute: .trailing,
                                    relatedBy: .equal,
                                    toItem: toastContainer,
                                    attribute: .trailing,
                                    multiplier: 1, constant: -15)
        let label3 = NSLayoutConstraint(item: toastLabel,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: toastContainer,
                                    attribute: .bottom,
                                    multiplier: 1, constant: -15)
        let label4 = NSLayoutConstraint(item: toastLabel,
                                    attribute: .top,
                                    relatedBy: .equal,
                                    toItem: toastContainer,
                                    attribute: .top,
                                    multiplier: 1, constant: 15)
        toastContainer.addConstraints([label1, label2, label3, label4])

        let constraint1 = NSLayoutConstraint(item: toastContainer,
                                    attribute: .leading,
                                    relatedBy: .equal,
                                    toItem: self.view,
                                    attribute: .leading,
                                    multiplier: 1, constant: 65)
        let constraint2 = NSLayoutConstraint(item: toastContainer,
                                    attribute: .trailing,
                                    relatedBy: .equal,
                                    toItem: self.view,
                                    attribute: .trailing,
                                    multiplier: 1, constant: -65)
        let constraint3 = NSLayoutConstraint(item: toastContainer,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: self.view,
                                    attribute: .bottom,
                                    multiplier: 1, constant: -75)
        self.view.addConstraints([constraint1, constraint2, constraint3])

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
