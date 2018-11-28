//
//  NewsDateFormatter.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/28.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation

class NewsDateFormatter {

    private static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale   = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }()

    // MARK: - Static Functions

    // APIで取得された日付フォーマットを任意の表記に変換する
    static func getDateStringFromAPI(apiDateString: String , printFormatter: String = "MMM dd, yyyy") -> String {

        // APIで取得してきたISO8601形式の日付文字列をDateへ変換する
        let formatterForApiDateString = ISO8601DateFormatter.init()
        let targetDate = formatterForApiDateString.date(from: apiDateString)

        // 変換を行いたいフォーマットの文字列へ再度変換を行う
        dateFormatter.dateFormat = printFormatter

        return dateFormatter.string(from: targetDate!)
    }
}
