//
//  CounterModel.swift
//  Counters
//
//  Created by DESARROLLO on 30/12/20.
//

import Foundation
import Alamofire

struct CounterModel: Codable {

    static let entityName: String = "Counter"

    let id: String?
    let title: String?
    var count: Int?
    var isSelected: Bool = false

    var asParams: Parameters {
        return [ "title": title ?? ""] as [String: Any]
    }
}
