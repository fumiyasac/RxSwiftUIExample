//
//  UIViewControllerExtension.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/28.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// UIViewControllerの拡張
extension UIViewController {

    // ナビゲーションバーを設定する
    func setupNavigationBar(title: String) {

        // NavigationControllerのデザイン調整をする
        var attributes = [NSAttributedString.Key : Any]()
        attributes[NSAttributedString.Key.font] = UIFont(name: AppConstant.COMMON_FONT_BOLD, size: AppConstant.COMMON_NAVIGATION_FONT_SIZE)
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.white

        // NavigationBarの調整をする
        self.navigationController!.navigationBar.titleTextAttributes = attributes
        self.navigationController!.navigationBar.isTranslucent = false

        // タイトルを表示する
        self.navigationItem.title = title
    }

    // 戻るボタンの「戻る」テキストを削除した状態にする
    // MEMO: NavigationControllerのrootとなるViewControllerへ設定する
    func removeBackButtonText() {
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
        self.navigationController!.navigationBar.tintColor = .white
    }
}
