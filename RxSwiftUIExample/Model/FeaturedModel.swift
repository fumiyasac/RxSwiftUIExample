//
//  FeaturedModel.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/12/05.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation

// MEMO: こちらのデータはViewModelから生成する
struct FeaturedModel {

    let id: Int
    let title: String
    let imageName: String

    // MARK: - Initializer

    init(id: Int, title: String, imageName: String) {
        self.id        = id
        self.title     = title
        self.imageName = imageName
    }
}
