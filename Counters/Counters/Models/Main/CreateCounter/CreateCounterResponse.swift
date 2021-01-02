//
//  CreateCounterResponse.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import Foundation

enum Status: String {
    case successful = "Successful"
    case error = "Error"
}

struct CreateCounterResponse {
    let status: Status
    let message: String
}
