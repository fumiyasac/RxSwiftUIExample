//
//  MainViewController.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/25.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit
import Floaty
import FontAwesome_swift

class MainViewController: UIViewController {

    @IBOutlet weak private var mainScrollView: UIScrollView!
    @IBOutlet weak private var floatyMenuButton: Floaty!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUserInterface()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private Function

    @objc private func hideFloatyMenuButton() {
        floatyMenuButton.close()
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideFloatyMenuButton), name: UIApplication.willResignActiveNotification, object: nil)
    }

    private func setupUserInterface() {
        setupNavigationBar(title: "World News Archives")
        setupFloatyMenuButton()
        removeBackButtonText()
    }

    private func setupFloatyMenuButton() {

        // メニューボタンのデザインを設定する
        floatyMenuButton.buttonColor = AppConstant.COMMON_POINT_COLOR
        floatyMenuButton.plusColor = .white
        floatyMenuButton.overlayColor = UIColor.black.withAlphaComponent(0.67)

        // MenuButtonTypesの定義からボタンアイテムを配置する
        let _ = MenuButtonTypes.allCases.map {

            // ボタンアイテムを設定する
            let menuButtonCase = $0
            let item = FloatyItem()

            // ボタンアイテムのタップ時挙動を設定する
            item.handler = { _ in
                let sb = UIStoryboard(name: menuButtonCase.getStoryboardName(), bundle: nil)
                if let vc = sb.instantiateInitialViewController() {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }

            // ボタンアイテムのデザインを設定する
            decorarteFloatyMenuButton(item: item, type: menuButtonCase)

            // ボタンアイテムを配置する
            floatyMenuButton.addItem(item: item)
         }
    }

    private func decorarteFloatyMenuButton(item: FloatyItem, type: MenuButtonTypes) {
        let itemOrigin = CGPoint(x: 7.0, y: 7.0)
        let itemSize = CGSize(width: 28.0, height: 28.0)

        // タイトル文字列設定
        item.title = type.getButtonName()

        // ボタンの色設定
        item.buttonColor = UIColor(code: "#333333", alpha: 0.5)

        // 表示ラベルのフォント設定
        item.titleLabel.textAlignment = .right
        item.titleLabel.font = UIFont(name: AppConstant.COMMON_FONT_BOLD, size: AppConstant.COMMON_NAVIGATION_FONT_SIZE)

        // ボタン右のアイコン表示設定
        item.iconImageView.tintColor = .white
        item.iconImageView.frame = CGRect(origin: itemOrigin, size: itemSize)
        item.iconImageView.image = UIImage.fontAwesomeIcon(name: type.getFontAwesomeIcon(), style: .solid, textColor: .white, size: itemSize)
    }
}
