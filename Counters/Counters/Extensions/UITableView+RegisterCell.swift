//
//  UITableView+RegisterCell.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import UIKit

extension UITableView {

    /// Register a cell from a given nib file class type
    /// Both nib name and reuse identifier will have the same string.
    /// - Parameter cellTypes: The cells that will registered
    func registerCells(_ cellTypes: [UITableViewCell.Type]) {
        cellTypes.forEach({ self.register($0.nib, forCellReuseIdentifier: $0.reuseIdentifier) })
    }
}

extension UICollectionView {

    /// Register a cell from a given nib file class type
    /// Both nib name and reuse identifier will have the same string.
    /// - Parameter cellTypes: The cells that will registered
    func registerCells(_ cellTypes: [UICollectionViewCell.Type]) {
        cellTypes.forEach({ self.register($0.nib, forCellWithReuseIdentifier: $0.reuseIdentifier) })
    }

    /// Register a cell from a given class type
    /// - Parameter cellTypes: The cells that will registered
    func registerCellClasses(_ cellTypes: [UICollectionViewCell.Type]) {
        cellTypes.forEach({ self.register($0.self, forCellWithReuseIdentifier: $0.reuseIdentifier) })
    }

    /// Register reusable views for a collection view header
    /// - Parameter views: The views that will registered
    func registerHeaderViews(_ views: [UICollectionReusableView.Type]) {
        views.forEach({
            let name = String(describing: $0)
            self.register(UINib(nibName: name, bundle: Bundle.this),
                          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                          withReuseIdentifier: name)
        })
    }
}
