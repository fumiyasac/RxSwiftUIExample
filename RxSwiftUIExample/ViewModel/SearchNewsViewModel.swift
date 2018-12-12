//
//  SearchNewsViewModel.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/12/09.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation
import SwiftyJSON

import RxSwift
import RxCocoa

class SearchNewsViewModel {

    private let newYorkTimesAPI: NewYorkTimesAPI!
    private let disposeBag = DisposeBag()

    let isLoading = BehaviorRelay<Bool>(value: false)
    let isError = BehaviorRelay<Bool>(value: false)
    let searchNewsLists = BehaviorRelay<[SearchNewsModel]>(value: [])

    // MARK: - Initializer

    init(api: NewYorkTimesAPI) {
        newYorkTimesAPI = api
    }

    // MARK: - Function

    func getSearchNews(keyword: String) {

        // リクエスト開始時の処理
        executeStartRequestAction()

        // ニュース記事のデータを取得する処理を実行する
        newYorkTimesAPI.getSearchNewsList(keyword: keyword).subscribe(

            // JSON取得が成功した場合の処理
            onSuccess: { json in
                let targetNewsList = self.getSearchNewsModelListsBy(json: json)
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

    private func executeSuccessResponseAction(newList: [SearchNewsModel]) {
        searchNewsLists.accept(newList)
        isLoading.accept(false)
    }

    private func executeErrorResponseAction() {
        isError.accept(true)
        isLoading.accept(false)
    }

    // レスポンスで受け取ったJSONから表示に必要なものを詰め直す
    private func getSearchNewsModelListsBy(json: JSON) -> [SearchNewsModel] {
        return json.map{ SearchNewsModel(json: $0.1) }
    }
}
