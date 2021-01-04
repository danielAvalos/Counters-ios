//
//  MessageModel.swift
//  Counters
//
//  Created by DESARROLLO on 3/01/21.
//

import Foundation

struct MessageModel {
    let title: String?
    let description: String?
    let action: ButtonItem?

    enum ButtonItem {
        case newCounter
        case reloadData

        var title: String {
            switch self {
            case .newCounter:
                return "Create a counter"
            case .reloadData:
                return "Retry"
            }
        }
    }
}
