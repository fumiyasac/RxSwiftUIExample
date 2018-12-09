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

import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    @IBOutlet weak private var mainScrollView: UIScrollView!
    @IBOutlet weak private var floatyMenuButton: Floaty!
    @IBOutlet weak private var recentNewsContainerViewHeightConstraint: NSLayoutConstraint!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // ContainerViewで表示しているViewControllerのプロトコルを適合する
        applyRecentNewsViewControllerDelegate(targetSegue: segue)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // UIまわりの初期設定
        setupUserInterface()

        // フォアグラウンドからバックグラウンドに移行する直前のタイミングでフロートボタン表示を戻す
        NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification, object: nil).subscribe(onNext:{ [weak self] _ in
            self?.floatyMenuButton.close()
        }).disposed(by: disposeBag)
    }

    // MARK: - Private Function

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
        floatyMenuButton.sticky = true

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

        // アイコンの配置位置とサイズを設定する
        let itemOrigin = CGPoint(x: 7.0, y: 7.0)
        let itemSize = CGSize(width: 28.0, height: 28.0)

        // タイトル文字列を設定する
        item.title = type.getButtonName()

        // ボタンの色を設定する
        item.buttonColor = UIColor(code: "#333333", alpha: 0.5)

        // 表示ラベルのフォントを設定する
        item.titleLabel.textAlignment = .right
        item.titleLabel.font = UIFont(name: AppConstant.COMMON_FONT_BOLD, size: AppConstant.COMMON_NAVIGATION_FONT_SIZE)

        // ボタン右のアイコン表示を設定する
        item.iconImageView.tintColor = .white
        item.iconImageView.frame = CGRect(origin: itemOrigin, size: itemSize)
        item.iconImageView.image = UIImage.fontAwesomeIcon(name: type.getFontAwesomeIcon(), style: .solid, textColor: .white, size: itemSize)
    }

    private func applyRecentNewsViewControllerDelegate(targetSegue: UIStoryboardSegue) {

        // Storyboardの名前からViewControllerのインスタンスを取得してprotocolを適用する
        if targetSegue.identifier == "ConnectRecentNewsContainer" {
            let vc = targetSegue.destination as! RecentNewsViewController
            vc.delegate = self
        }
    }
}

// MARK: - RecentNewsViewController

extension MainViewController: RecentNewsViewControllerDelegate {

    // このViewControllerを表示するためのContainerViewの高さを更新する
    func updateContainerViewHeight(_ height: CGFloat) {
        recentNewsContainerViewHeightConstraint.constant = height
    }
}
