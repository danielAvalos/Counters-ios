//
//  NibNameIdentifiable.swift
//  Counters
//
//  Created by DESARROLLO on 3/01/21.
//

import UIKit

public protocol NibNameIdentifiable {}

public extension NibNameIdentifiable where Self: UIView {
    static var identifier: String {
        String(describing: Self.self)
    }

    static var nib: UINib {
        UINib(nibName: Self.identifier, bundle: Bundle(for: Self.self))
    }
}
