//
//  InformationViewModel.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/12/06.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class InformationViewModel {

    // 内部で利用するためのプロパティ
    private let informationModelMaxCount: Int!
    private let informationLists: [InformationModel]!

    // ViewController側で利用するためのプロパティ
    let allTitles: Observable<[String]>!
    let selectedInformation = BehaviorRelay<InformationModel?>(value: nil)

    // MARK: - Initializer

    init(data: Data) {

        // JSONファイルから表示用のデータを取得してInformationModelの型に合致するようにする
        informationLists = try! JSONDecoder().decode([InformationModel].self, from: data)

        // タイトルの一覧を取得する
        allTitles = Observable<[String]>.just(informationLists.compactMap{ return $0.title })

        // 表示用のデータの個数を反映する
        informationModelMaxCount = informationLists.count

        // 最初に表示するのInformationModel要素を反映する
        selectedInformation.accept(informationLists.first)
    }

    // MARK: - Function

    // 表示したいインデックス値に該当する値(informationLists)を選択状態にする
    func switchSelectedInformation(indexPath: Int) {
        let targetIndex = adjustIndexPath(indexPath: indexPath)
        selectedInformation.accept(informationLists[targetIndex])
    }

    // MARK: - Private Function

    private func adjustIndexPath(indexPath: Int) -> Int {
        if 0...informationModelMaxCount - 1 ~= indexPath {
            return indexPath
        } else {
            return 0
        }
    }
}
