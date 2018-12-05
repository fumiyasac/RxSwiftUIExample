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

    private let featuredModelMaxCount = 3

    let shouldHidePreviousButton = BehaviorRelay<Bool>(value: true)
    let shouldHideNextButton = BehaviorRelay<Bool>(value: false)
    let currentIndex = BehaviorRelay<Int>(value: 0)
    let featuredLists = BehaviorRelay<[FeaturedModel]>(value: [])

    // MARK: - Initializer

    init() {

        // 表示用のデータを作成する
        let featuredListRange = (0...featuredModelMaxCount)
        featuredLists.accept(featuredListRange.compactMap{
            let id = $0 + 1
            return FeaturedModel(id: id, title: "Featured Sample [Index: \($0)]", imageName: "sample")
        })
    }

    // MARK: - Function

    // 現在表示すべきインデックス値を変更する
    func updateCurrentIndex(isIncrement: Bool = true) {

        // 現在のcurrentIndex.valueに対して「+1」または「-1」を行う
        let newIndex = isIncrement ? currentIndex.value + 1 : currentIndex.value - 1

        // 関連するプロパティの値を更新する
        shouldHidePreviousButton.accept((newIndex == 0))
        shouldHideNextButton.accept((newIndex == featuredModelMaxCount))
        currentIndex.accept(newIndex)
    }
}
