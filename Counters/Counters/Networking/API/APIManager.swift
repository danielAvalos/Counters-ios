//
//  APIManager.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {

    case getCounters
    case addCounter(counter: CounterModel)
    case incrementCounter(counter: CounterModel)
    case decrementCounter(counter: CounterModel)
    case deleteCounter(counter: CounterModel)

    var method: HTTPMethod {
        switch self {
        case .addCounter, .incrementCounter, .decrementCounter:
            return .post
        case .deleteCounter:
            return .delete
        case .getCounters:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getCounters:
            return "/api/v1/counters"
        case .addCounter, .deleteCounter:
            return "/api/v1/counter"
        case .incrementCounter:
            return "/api/v1/counter/inc"
        case .decrementCounter:
            return "api/v1/counter/dec"
        }
    }

    var parameters: Parameters {
        switch self {
        case .getCounters:
            return [:]
        case let .addCounter(counter),
             let .incrementCounter(counter),
             let .decrementCounter(counter):
            return counter.asParams
        default:
            return [:]
        }
    }

    var encoding: ParameterEncoding {
        switch method {
        default:
            return JSONEncoding.default
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try Config.apiBaseUrl.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest = try encoding.encode(urlRequest, with: parameters)
        return urlRequest
    }

    func asURLString() -> String {
        do {
            let url = try Config.apiBaseUrl.asURL().appendingPathComponent(path).absoluteString
            return url
        } catch {
            return ""
        }
    }

    func asURL() -> URL {
        let urlString = Config.apiBaseUrl.appending(path).replacingOccurrences(of: " ", with: "%20")
        // swiftlint:disable:next force_unwrapping
        return URL(string: urlString)!
    }
}

struct Config {
    static let apiBaseUrl = "http://localhost:3000/"
}
