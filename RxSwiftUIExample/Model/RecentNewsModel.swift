//
//  RecentNewsModel.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/12/07.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation
import SwiftyJSON

// MEMO: New York Timesの公開APIのレスポンスが複雑なのでJSONの解析にはSwiftyJSONを利用している
struct RecentNewsModel {

    let newsTitle: String
    let newsWebUrlString: String
    let newsByLine: String
    let newsDate: String

    init(json: JSON) {

        // New York Timesの公開APIから必要なものを取得した上で初期化処理を行う
        // 確認URL: http://developer.nytimes.com/article_search_v2.json#/Console/GET/articlesearch.json
        self.newsTitle        = json["headline"]["main"].string       ?? ""
        self.newsWebUrlString = json["web_url"].string                ?? ""
        self.newsByLine       = json["byline"]["organization"].string ?? "--"

        // 日付についてはIOS8601形式の文字列を変換して初期化処理を行う
        if let newsDate = json["pub_date"].string {
            self.newsDate = NewsDateFormatter.getDateStringFromAPI(apiDateString: newsDate)
        } else {
            self.newsDate = "--"
        }
    }
}
