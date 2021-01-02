//
//  UITableViewCell+RegisterCell.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import UIKit

extension UITableViewCell {

    static var reuseIdentifier: String { return String(describing: self) }

    static var nibName: String { return Self.reuseIdentifier }

    static var nib: UINib { return UINib(nibName: nibName, bundle: Bundle.this) }

}

extension UICollectionViewCell {

    static var reuseIdentifier: String { return String(describing: self) }

    static var nibName: String { return Self.reuseIdentifier }

    static var nib: UINib { return UINib(nibName: nibName, bundle: Bundle.this) }

}

extension Bundle {
    static var this: Bundle = { Bundle(for: THIS.self) }()
}

class THIS {}
