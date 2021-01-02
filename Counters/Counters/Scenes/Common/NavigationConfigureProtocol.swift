//
//  NavigationConfigureProtocol.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import UIKit

enum BarButtonItemTag: Int {
    case edit
    case cancel
    case save
    case share
    case selectAll
    case unselectAll
    case done
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
            switch item {
            case BarButtonItemTag.cancel:
                let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapBarItem))
                cancel.tag = BarButtonItemTag.cancel.rawValue
                barButtonItems.append(cancel)
            case BarButtonItemTag.edit:
                let edit = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didTapBarItem))
                edit.tag = BarButtonItemTag.edit.rawValue
                barButtonItems.append(edit)
            case BarButtonItemTag.done:
                let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapBarItem))
                done.tag = BarButtonItemTag.done.rawValue
                barButtonItems.append(done)
            case BarButtonItemTag.save:
                let save = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapBarItem))
                save.tag = BarButtonItemTag.save.rawValue
                barButtonItems.append(save)
            case BarButtonItemTag.share:
                let share = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(didTapBarItem))
                share.tag = BarButtonItemTag.share.rawValue
                barButtonItems.append(share)
            case BarButtonItemTag.selectAll:
                let selectAll = UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(didTapBarItem))
                selectAll.tag = BarButtonItemTag.selectAll.rawValue
                barButtonItems.append(selectAll)
            case .unselectAll:
                let selectAll = UIBarButtonItem(title: "Unselect All", style: .plain, target: self, action: #selector(didTapBarItem))
                selectAll.tag = BarButtonItemTag.unselectAll.rawValue
                barButtonItems.append(selectAll)
            }
        }
        return barButtonItems
    }
}
