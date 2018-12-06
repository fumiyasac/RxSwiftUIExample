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

    private let informationLists: [InformationModel]!

    // ViewController側で利用するためのプロパティ
    let allTitleLists: [String]!
    let selectedInformation = BehaviorRelay<InformationModel?>(value: nil)

    // MARK: - Initializer

    init(data: Data) {

        // ローカル内のJSONファイルから表示用のデータを取得してInformationModelの型に合致するようにする
        informationLists = try! JSONDecoder().decode([InformationModel].self, from: data)

        // タイトルの一覧を取得する
        allTitleLists = informationLists.compactMap{ return $0.title }

        // 現在せ表示中のInformationModel要素を保持する
        selectedInformation.accept(informationLists.first)
    }

    // MARK: - Function

    // 表示したいインデックス値に該当する値(informationLists)を選択状態にする
    func switchSelectedInformation(indexPath: Int) {
        selectedInformation.accept(informationLists[indexPath])
    }
}
