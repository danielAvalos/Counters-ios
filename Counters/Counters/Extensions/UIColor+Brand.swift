//
//  UIColor+Brand.swift
//  Counters
//
//  Created by DESARROLLO on 30/12/20.
//

import UIKit

enum ColorsCustomized: String {
    case green =  "greenColor"
    case orange = "orangeColor"
    case yellow = "yellowColor"
    case red = "redColor"
    case black = "blackColor"
}

extension UIColor {

    static func color(named: ColorsCustomized) -> UIColor? {
        return UIColor(named: named.rawValue)
    }
}
