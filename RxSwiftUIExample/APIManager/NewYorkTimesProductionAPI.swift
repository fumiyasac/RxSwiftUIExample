//
//  NewYorkTimesProductionAPI.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/29.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

import RxSwift
import RxCocoa

class NewYorkTimesProductionAPI: NewYorkTimesAPI {

    private let manager = AF
    private let baseUrl = "https://api.nytimes.com/svc/search/v2/articlesearch.json"
    private let key = AppConstant.NEWYORKTIMES_API_KEY

    // MARK: - Functions

    // NewYorkTimesの最新ニュース一覧を取得する
    func getRecentNewsList(page: Int = 0) -> Single<JSON> {

        // APIにリクエストする際に必要なパラメーターを定義する
        let parameters: [String : Any] = [
            "api-key" : key,
            "sort"    : "newest",
            "fl"      : "web_url,pub_date,headline,byline",
            "page"    : page
        ]

        // APIへのリクエストを1度だけ送信して結果に応じた処理をする
        return Single<JSON>.create(subscribe: { singleEvent in
            self.manager.request(self.baseUrl, method: .get, parameters: parameters).validate().responseJSON { response in
                switch response.result {

                // APIからのレスポンスの取得成功時
                case .success(let response):
                    let res = JSON(response)
                    let json = res["response"]["docs"]
                    singleEvent(.success(json))

                // APIからのレスポンスの取得失敗時
                case .failure(let error):
                    singleEvent(.failure(error))
                }
            }
            return Disposables.create()
        })
    }

    // キーワードを元にNewYorkTimesの検索結果に紐づくニュース一覧を取得する
    func getSearchNewsList(keyword: String) -> Single<JSON> {

        // APIにリクエストする際に必要なパラメーターを定義する
        let parameters: [String : Any] = [
            "api-key" : key,
            "sort"    : "newest",
            "fl"      : "web_url,snippet,headline",
            "q"       : keyword,
        ]

        // APIへのリクエストを1度だけ送信して結果に応じた処理をする
        return Single<JSON>.create(subscribe: { singleEvent in
            self.manager.request(self.baseUrl, method: .get, parameters: parameters).validate().responseJSON { response in
                switch response.result {

                // APIからのレスポンスの取得成功時
                case .success(let response):
                    let res = JSON(response)
                    let json = res["response"]["docs"]
                    singleEvent(.success(json))

                // APIからのレスポンスの取得失敗時
                case .failure(let error):
                    singleEvent(.failure(error))
                }
            }
            return Disposables.create()
        })
    }
}


