//
//  SearchNewsModel.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/12/09.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation
import SwiftyJSON

// MEMO: New York Timesの公開APIのレスポンスが複雑なのでJSONの解析にはSwiftyJSONを利用している
struct SearchNewsModel {

    let newsTitle: String
    let newsWebUrlString: String
    let newsSnippet: String

    init(json: JSON) {

        // New York Timesの公開APIから必要なものを取得した上で初期化処理を行う
        // 確認URL: http://developer.nytimes.com/article_search_v2.json#/Console/GET/articlesearch.json
        self.newsTitle        = json["headline"]["main"].string ?? ""
        self.newsWebUrlString = json["web_url"].string          ?? ""
        self.newsSnippet      = json["snippet"].string          ?? "--"
    }
}
