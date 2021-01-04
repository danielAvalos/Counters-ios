//
//  MainResponse.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import Foundation

struct MainResponse {
    let messageItemSelected: String
    let counters: [CounterModel]
    let isSearching: Bool
}
