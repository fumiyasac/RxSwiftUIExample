//
//  AppConstant.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/28.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation
import UIKit

struct AppConstant {

    // アプリ共通の設定
    static let COMMON_FONT_NORMAL: String = "Helvetica"
    static let COMMON_FONT_BOLD: String = "Helvetica-Bold"
    static let COMMON_POINT_COLOR: UIColor = UIColor(code: "#28385e")

    // ナビゲーションバーの設定
    static let COMMON_NAVIGATION_FONT_SIZE: CGFloat = 14.0

    // ドロップダウンメニューの設定
    static let COMMON_DROPDOWN_MENU_FONT_SIZE: CGFloat = 12.0

    // 検索バーの設定
    static let SEARCHBAR_TEXTFIELD_BACKGROUND_COLOR: UIColor = .white
    static let SEARCHBAR_TEXTFIELD_TINT_COLOR: UIColor = UIColor(code: "#666666")
    static let SEARCHBAR_TEXTFIELD_FONT_SIZE: CGFloat = 13.0
    static let SEARCHBAR_PLACEHOLDER_TINT_COLOR: UIColor = .lightGray
    static let SEARCHBAR_PLACEHOLDER_FONT_SIZE: CGFloat = 13.0

    // Toastの設定
    static let TOAST_TINT_COLOR: UIColor = .white
    static let TOAST_FONT_SIZE: CGFloat = 12.0
}

