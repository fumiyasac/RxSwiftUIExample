//
//  RecentNewsViewModel.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/12/07.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation
import SwiftyJSON

import RxSwift
import RxCocoa

class RecentNewsViewModel {

    private let newYorkTimesAPI: NewYorkTimesAPI!
    private let disposeBag = DisposeBag()

    private var targetPage = 0

    // ViewController側で利用するためのプロパティ
    let isLoading = BehaviorRelay<Bool>(value: false)
    let isError = BehaviorRelay<Bool>(value: false)
    let recentNewsLists = BehaviorRelay<[RecentNewsModel]>(value: [])

    // MARK: - Initializer

    init(api: NewYorkTimesAPI) {
        newYorkTimesAPI = api
    }

    // MARK: - Function
    
    func getRecentNews() {

        // リクエスト開始時の処理
        executeStartRequestAction()

        // ニュース記事のデータを取得する処理を実行する
        newYorkTimesAPI.getRecentNewsList(page: targetPage).subscribe(

            // JSON取得が成功した場合の処理
            onSuccess: { json in
                let targetNewsList = self.getRecentNewsModelListsBy(json: json)
                self.executeSuccessResponseAction(newList: targetNewsList)
            },

            // JSON取得が失敗した場合の処理
            onError: { error in
                self.executeErrorResponseAction()
                print("Error: ", error.localizedDescription)
            }

        ).disposed(by: disposeBag)
    }

    // MARK: - Private Function

    private func executeStartRequestAction() {
        isLoading.accept(true)
        isError.accept(false)
    }

    private func executeSuccessResponseAction(newList: [RecentNewsModel]) {
        recentNewsLists.accept(recentNewsLists.value + newList)
        targetPage += 1
        isLoading.accept(false)
    }

    private func executeErrorResponseAction() {
        isError.accept(true)
        isLoading.accept(false)
    }

    // レスポンスで受け取ったJSONから表示に必要なものを詰め直す
    private func getRecentNewsModelListsBy(json: JSON) -> [RecentNewsModel] {
        return json.map{ RecentNewsModel(json: $0.1) }
    }
}
