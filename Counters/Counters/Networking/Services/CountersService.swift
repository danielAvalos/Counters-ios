//
//  CountersService.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import Foundation
import Alamofire

final class CountersService {

    func createCounter(model: CounterModel, completionHandler: @escaping ([CounterModel]?, ErrorModel?) -> Void) {
        request(apiRouter: APIRouter.addCounter(counter: model),
                completionHandler: completionHandler)
    }

    func fetchCounters(completionHandler: @escaping ([CounterModel]?, ErrorModel?) -> Void) {
        request(apiRouter: APIRouter.getCounters, completionHandler: completionHandler)
    }

    func incrementCounter(model: CounterModel, completionHandler: @escaping ([CounterModel]?, ErrorModel?) -> Void) {
        request(apiRouter: APIRouter.incrementCounter(counter: model),
                completionHandler: completionHandler)
    }

    func decrementCounter(model: CounterModel, completionHandler: @escaping ([CounterModel]?, ErrorModel?) -> Void) {
        request(apiRouter: APIRouter.decrementCounter(counter: model),
                completionHandler: completionHandler)
    }

    func deleteCounter(model: CounterModel, completionHandler: @escaping ([CounterModel]?, ErrorModel?) -> Void) {
        request(apiRouter: APIRouter.deleteCounter(counter: model),
                completionHandler: completionHandler)
    }

    private func request(apiRouter: APIRouter, completionHandler: @escaping ([CounterModel]?, ErrorModel?) -> Void) {
        let request = AF.request(apiRouter)
        request.responseDecodable(of: [CounterModel].self) { (response) in
            guard let httpURLResponse = response.response else {
                completionHandler(nil, ErrorModel(code: .errorServer, descriptionLocalizable: response.error?.errorDescription))
                return
            }
            switch httpURLResponse.statusCode {
            case 200, 204:
                completionHandler(response.value, nil)
            case 400:
                completionHandler(nil, ErrorModel(code: .badRequest))
            case 404:
                completionHandler(nil, ErrorModel(code: .notFound))
            case 500:
                completionHandler(nil, ErrorModel(code: .errorServer))
            default:
                completionHandler(nil, ErrorModel(code: .unknown))
            }
        }
    }

}
