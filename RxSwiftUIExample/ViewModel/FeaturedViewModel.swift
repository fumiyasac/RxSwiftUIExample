//
//  FeaturedViewModel.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/12/05.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FeaturedViewModel {

    // 内部で利用するためのプロパティ
    private let featuredModelMaxCount: Int!

    // ViewController側で利用するためのプロパティ
    let featuredLists: Observable<[FeaturedModel]>!
    let shouldHidePreviousButton = BehaviorRelay<Bool>(value: true)
    let shouldHideNextButton = BehaviorRelay<Bool>(value: false)
    let currentIndex = BehaviorRelay<Int>(value: 0)

    // MARK: - Initializer

    init(data: Data) {

        // JSONファイルから表示用のデータを取得してFeaturedModelの型に合致するようにする
        let featuredModels = try! JSONDecoder().decode([FeaturedModel].self, from: data)

        // 表示用のデータの個数を反映する
        featuredModelMaxCount = featuredModels.count

        // 表示用のデータを反映する
        featuredLists = Observable<[FeaturedModel]>.just(featuredModels)
    }

    // MARK: - Function

    // 現在表示すべきインデックス値を変更する
    func updateCurrentIndex(isIncrement: Bool = true) {

        // 現在のcurrentIndex.valueに対して「+1」または「-1」を行う
        let targetIndex = adjustNewIndex(isIncrement: isIncrement)

        // 関連するプロパティの値を更新する
        shouldHidePreviousButton.accept((targetIndex == 0))
        shouldHideNextButton.accept((targetIndex == featuredModelMaxCount - 1))
        currentIndex.accept(targetIndex)
    }

    // MARK: - Private Function

    private func adjustNewIndex(isIncrement: Bool = true) -> Int {
        let newIndex = isIncrement ? currentIndex.value + 1 : currentIndex.value - 1
        if newIndex > featuredModelMaxCount - 1 {
            return featuredModelMaxCount - 1
        } else if newIndex < 0 {
            return 0
        } else {
            return newIndex
        }
    }
}
