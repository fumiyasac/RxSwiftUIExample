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

    private let featuredModelMaxCount = 6

    private(set) var shouldHidePreviousButton = BehaviorRelay<Bool>(value: true)
    private(set) var shouldHideNextButton = BehaviorRelay<Bool>(value: false)
    private(set) var currentIndex = BehaviorRelay<Int>(value: 0)
    private(set) var featuredLists = BehaviorRelay<[FeaturedModel]>(value: [])

    // MARK: - Initializer

    init() {
        // 表示用のデータを作成する
        let featuredListRange = (0...featuredModelMaxCount)
        featuredLists.accept(featuredListRange.map{
            return FeaturedModel(id: $0, title: "Featured Sample \($0)", imageName: "sample")
        })
    }

    // MARK: - Function

    // 現在表示すべきインデックス値を変更する
    func updateCurrentIndex(isIncrement: Bool = true) {
        let newIndex = isIncrement ? currentIndex.value + 1 : currentIndex.value - 1
        shouldHidePreviousButton.accept((newIndex == 0))
        shouldHideNextButton.accept((newIndex == featuredModelMaxCount - 1))
        currentIndex.accept(newIndex)
    }
}
