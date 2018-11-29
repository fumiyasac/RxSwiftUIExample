//
//  NewYorkTimesAPI.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/29.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation

protocol NewYorkTimesAPI {
    // 最新ニュースを10件ずつ取得する
    //func getRecentNews(perPage number: Int) -> Observable<[NewYorkTimesNewsTop]>
    // 引数の文字列情報を元に検索する
    //func searchNews(from word: String) -> Observable<[NewYorkTimesNewsSearch]>
}

class NewYorkTimesDefaultAPI: NewYorkTimesAPI {

    // APIへのリクエストの際にあらかじめ必要な設定
    private let apiKey = "0d3a37b2678f40daa3243509b4ed4d13"
    private let sortOrder = "newest"
    private let targetDataKeys = "web_url,pub_date,headline,document_type,section_name,byline"
}

