//
//  ErrorModel.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import Foundation

struct ErrorModel: ErrorRepresentable {

    var description: String {
        switch code {
        case .notConnection:
            return "Please check your internet connection and try again"
        case .unknown, .badRequest, .notFound:
            return "Something went wrong, please check your connection and try again"
        case .errorServer:
            return "Something went wrong, the service is not available, please try again later"
        case .other:
            return descriptionLocalizable ?? ""
        }
    }

    var title: String {
        switch code {
        case .notConnection:
            return "Not Connection"
        case .unknown:
            return "Unknow"
        case .badRequest:
            return "Bad Request"
        case .notFound:
            return "Not Found"
        case .errorServer:
            return "Error in Server"
        case .other:
            return descriptionLocalizable ?? ""
        }
    }

    var code: ErrorCode
    var descriptionLocalizable: String?
}

protocol ErrorRepresentable {
    var code: ErrorCode { get set }
}

enum ErrorCode {
    case notConnection
    case unknown
    case badRequest
    case errorServer
    case notFound
    case other
}
