//
//  NavigationConfigureProtocol.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import UIKit

enum BarButtonItemTag: Int {
    case cancel
    case create
    case done
    case edit
    case save
    case share
    case selectAll
    case unselectAll

    var title: String {
        switch self {
        case .cancel:
            return "Cancel"
        case .create:
            return "Create"
        case .done:
            return "Done"
        case .edit:
            return "Edit"
        case .save:
            return "Save"
        case .share:
            return "Share"
        case .selectAll:
            return "Select All"
        case .unselectAll:
            return "Unselect All"
        }
    }
}

@objc protocol NavigationConfigureProtocol {
    func didTapBarItem(sender: UIBarButtonItem)
}

extension NavigationConfigureProtocol where Self: UIViewController {
    func showActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.startAnimating()
        let activityIndicatorBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
        navigationItem.rightBarButtonItem = activityIndicatorBarButtonItem
    }

    func showRightBarButtonItems(navigationItem: UINavigationItem, items: [BarButtonItemTag]) {
        let items = getBarButtonItems(items: items)
        navigationItem.rightBarButtonItems = nil
        navigationItem.rightBarButtonItems = items
    }

    func showLeftBarButtonItems(navigationItem: UINavigationItem, items: [BarButtonItemTag]) {
        let items = getBarButtonItems(items: items)
        navigationItem.leftBarButtonItems = nil
        navigationItem.leftBarButtonItems = items
    }

    private func getBarButtonItems(items: [BarButtonItemTag]) -> [UIBarButtonItem]? {
        var barButtonItems: [UIBarButtonItem] = [UIBarButtonItem]()
        for item in items {
            let action = UIBarButtonItem(title: item.title, style: .plain, target: self, action: #selector(didTapBarItem))
            action.tag = item.rawValue
            action.tintColor = UIColor.color(named: .orange)
            barButtonItems.append(action)
        }
        return barButtonItems
    }
}
