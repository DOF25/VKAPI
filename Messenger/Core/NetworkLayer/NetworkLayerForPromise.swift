//
//  NetworkLayerForPromise.swift
//  Messenger
//
//  Created by Крылов Данила  on 07.10.2021.
//

import Foundation
import SwiftyJSON
import PromiseKit
import Alamofire

final class NetworkLayerForPromise {

    static let shared = NetworkLayerForPromise()

    private init() { }

    func downloadJsonGroups(url: String) -> Promise<[Groups]> {

        let (promise, resolver) = Promise<[Groups]>.pending()

            AF.request(url).responseJSON { response in
                if let data = response.data {
                    do {
                        let json = try JSON(data: data)
                        let groups = json["response"]["items"].arrayValue
                            .map { Groups(json: $0) }
                        resolver.fulfill(groups)
                    } catch {
                        resolver.reject(error)
                    }
                }

                if let error = response.error {
                    resolver.reject(error)
                }
            }

        return promise

    }

    
}
