//
//  KeywordSearchBar.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/30.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class KeywordSearchBar: UISearchBar {

    private let searchBarHeight: CGFloat = 44.0
    private let searchBarPaddingTop: CGFloat = 8.0

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupKeywordSearchBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupKeywordSearchBar()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        decorateKeywordSearchBar()
    }

    // MARK: - Private Functions

    private func decorateKeywordSearchBar() {

        // key名からテキストフィールド要素を取得する
        if let textField = self.value(forKey: "searchField") as? UITextField {

            // iOS11以降の場合だけ高さを書き換える
            if #available(iOS 11.0, *) {
                let textFieldHeight = searchBarHeight - searchBarPaddingTop * 2
                textField.frame = CGRect(x: textField.frame.origin.x, y: searchBarPaddingTop, width: textField.frame.width, height: textFieldHeight)
            }

            // テキストフィールド部分のデザインを設定する
            textField.backgroundColor = AppConstant.SEARCHBAR_TEXTFIELD_BACKGROUND_COLOR
            textField.tintColor = AppConstant.SEARCHBAR_TEXTFIELD_TINT_COLOR
            textField.font = UIFont(name: AppConstant.COMMON_FONT_NORMAL, size: AppConstant.SEARCHBAR_TEXTFIELD_FONT_SIZE)

            // プレースホルダ部分のデザインを設定する
            if let label = textField.value(forKey: "placeholderLabel") as? UILabel {
                label.textColor = AppConstant.SEARCHBAR_PLACEHOLDER_TINT_COLOR
                label.font = UIFont(name: AppConstant.COMMON_FONT_NORMAL, size: AppConstant.SEARCHBAR_PLACEHOLDER_FONT_SIZE)
            }
        }
    }

    private func setupKeywordSearchBar() {

        // iOS11以降の場合だけLayoutAnchorを利用して制約を付与する
        if #available(iOS 11.0, *) {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.heightAnchor.constraint(equalToConstant: searchBarHeight).isActive = true
        }
    }
}
