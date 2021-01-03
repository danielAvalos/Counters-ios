//
//  ReachabilityManager.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import Reachability

struct ReachabilityManager {

    ///returns the current state of the connection
    var isConnected: Bool {
        do {
            let reachability = try Reachability()
            return reachability.connection != .unavailable
        } catch {
            print("Unable to start notifier")
        }
        return false
    }
}
