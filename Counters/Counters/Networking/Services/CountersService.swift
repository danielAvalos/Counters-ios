//
//  CountersService.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import Foundation
import Alamofire

final class CountersService {

    func fetchCountersAF(completionHandler: @escaping ([CounterModel]?, ErrorModel?) -> Void) {
        let request = AF.request(APIRouter.getCounters)
        request.responseDecodable(of: [CounterModel].self) { (response) in
            guard let counterModel = response.value else { return }
            completionHandler(counterModel, nil)
        }
    }

    func fetchCounters(completionHandler: @escaping ([CounterModel]?, ErrorModel?) -> Void) {
        let task = URLSession.shared.dataTask(with: APIRouter.getCounters.asURL()) { (data, response, _) in
            guard let data = data else {
                guard let httpURLResponse = response as? HTTPURLResponse else {
                    return
                }
                switch httpURLResponse.statusCode {
                case 400:
                    completionHandler(nil, ErrorModel(code: .badRequest))
                case 404:
                    completionHandler(nil, ErrorModel(code: .notFound))
                case 500:
                    completionHandler(nil, ErrorModel(code: .errorServer))
                default:
                    completionHandler(nil, ErrorModel(code: .unknown))
                }
                return
            }
            do {
                let sites = try JSONDecoder().decode([CounterModel].self, from: data)
                completionHandler(sites, nil)
            } catch let error {
                completionHandler(nil, ErrorModel(code: .other, descriptionLocalizable: error.localizedDescription))
            }
        }
        task.resume()
    }
}
