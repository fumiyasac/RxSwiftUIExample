//
//  UISearchBarExtension.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/28.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// UISearchBarの拡張
extension UISearchBar {

    // 検索バーのデザインを設定する
    func decorateSearchBar() {

        // 再帰的にUISearchBar内の子Viewを取得する
        var recursiveDetectSubviews: ( (UIView) -> Void)?
        recursiveDetectSubviews = { view in
            view.subviews.forEach { subview in
                if let textField = subview as? UITextField {

                    // テキストフィールドのデザインを設定する
                    textField.tintColor = AppConstant.SEARCHBAR_TEXT_FIELD_TINT_COLOR
                    textField.backgroundColor = AppConstant.SEARCHBAR_TEXT_FIELD_BACKGROUND_COLOR
                    textField.font = UIFont(name: AppConstant.COMMON_FONT_NORMAL, size: AppConstant.SEARCHBAR_TEXT_FIELD_FONT_SIZE)

                    // テキストフィールドのプレースホルダー内のラベル色を変更する
                    let textFieldInsideUISearchBarLabel = textField.value(forKey: "placeholderLabel") as? UILabel
                    textFieldInsideUISearchBarLabel?.textColor = AppConstant.SEARCHBAR_TEXT_FIELD_PLACEHOLDER_COLOR
                    
                } else {
                    recursiveDetectSubviews?(subview)
                }
            }
        }
        recursiveDetectSubviews?(self)
    }
}
