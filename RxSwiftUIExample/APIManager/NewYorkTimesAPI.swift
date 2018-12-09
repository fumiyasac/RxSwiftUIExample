//
//  NewYorkTimesAPI.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/12/08.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation
import SwiftyJSON

import RxSwift
import RxCocoa

protocol NewYorkTimesAPI {
    func getRecentNewsList(page: Int) -> Single<JSON>
    func getSearchNewsList(keyword: String) -> Single<JSON>
}
