//
//  NetworkManager.swift
//  KakaoBankTest
//
//  Created by Hwangho Kim on 2020/04/23.
//  Copyright © 2020 lge. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift

class NetworkManager: NSObject {
    static let `default` = NetworkManager.init()

    let domain = "https://itunes.apple.com/search"

    var disposeBag = DisposeBag()
    
    private override init() {
        super.init()
    }

    func searchRequest(with term: String) -> Single<[SearchResult]> {

        guard var components = URLComponents(string: domain) else {
            return Single.error(NSError(domain: "Failed to make components", code: 0, userInfo: nil))
        }

        components.query = """
        &country=\(Locale.current.regionCode ?? "KR")\
        &media=software\
        &term=\(term)
        """

        guard let url = components.url else {
            print("Failed to get url")
            return Single.error(NSError(domain: "Failed to get url", code: 0, userInfo: nil))
        }

        let defaultUrlSession = URLSession(configuration: .default)


        return defaultUrlSession.rx.data(request: URLRequest.init(url: url)).asSingle()
            .flatMap { (data) -> Single<SearchResultModel> in
                return Single.create { (observer) -> Disposable in
                    do {
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(SearchResultModel.self, from: data)
                        observer(.success(model))
                    } catch {
                        observer(.error(NSError(domain: "Failed to make SearchResultModel", code: 0, userInfo: nil)))
                    }
                    return Disposables.create()
                }
        }.map { (searchResultModel) -> [SearchResult] in
            return (searchResultModel).results ?? []
        }

        //        let dataTask = defaultUrlSession.dataTask(with: url) { (data, response, error) in
        //
        //            guard error == nil else {
        //                print(error?.localizedDescription ?? "Invalid response")
        //                return
        //            }
        //
        //            guard let data = data, let result = response as? HTTPURLResponse, result.statusCode == 200 else {
        //                print("Invalid response")
        //                return
        //            }
        //
        //            do {
        //                let decoder = JSONDecoder()
        //                let model = try decoder.decode(SearchResultModel.self, from: data)
        //                completionHandler?(model)
        //            } catch {
        //                completionHandler?(nil)
        //                print(error)
        //            }
        //        }
        //
        //        dataTask.resume()
    }
}
