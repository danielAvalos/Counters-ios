//
//  CounterModel.swift
//  Counters
//
//  Created by DESARROLLO on 30/12/20.
//

import Foundation
import Alamofire

struct CounterModel {

    static let entityName: String = "Counter"

    let id: String?
    let title: String?
    var count: Int = 0
    var isSelected: Bool = false

    var asParams: Parameters {
        var params = [ "title": title ?? ""] as [String: Any]
        if let id = id {
            params["id"] = id
        }
        return params
    }
}

extension CounterModel: Codable {

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case count
    }
}
