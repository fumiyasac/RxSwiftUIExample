//
//  InformationViewController.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/29.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

import RxSwift
import RxCocoa

class InformationViewController: UIViewController {

    private let originalInformationTopImageHeight: CGFloat = 240
    private let disposeBag = DisposeBag()

    private var menuView: BTNavigationDropdownMenu!

    @IBOutlet weak private var informationScrollView: UIScrollView!
    @IBOutlet weak private var informationTopImageView: UIImageView!
    @IBOutlet weak private var informationTitleLabel: UILabel!
    @IBOutlet weak private var informationSummaryLabel: UILabel!

    // TOP画像において変更対象となるAutoLayoutの制約値
    @IBOutlet private weak var informationTopImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var informationTopImageTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // UIまわりの初期設定
        setupUserInterface()

        // ViewModelの初期化
        let informationViewModel = InformationViewModel(data: getDataFromJSONFile())

        // ドロップダウンメニューの初期化をする処理
        informationViewModel.allTitles.subscribe(onNext: { [weak self] in
            let targetTitles = $0.map{$0}
            self?.initializeDropDownMenuDataLists(targetViewModel: informationViewModel, targetTitles: targetTitles)
            self?.initializeDropDownMenuDecoration()
        }).disposed(by: disposeBag)

        // 選択された情報を表示する処理
        informationViewModel.selectedInformation.asDriver().drive(onNext: { [weak self] in
            self?.informationScrollView.setContentOffset(CGPoint.zero, animated: true)
            self?.displayInformation(targetModel: $0)
        }).disposed(by: disposeBag)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // メニューを表示した状態から前の画面へ戻る場合に対する考慮をする
        menuView.hide()
    }

    // MARK: - Private Function

    private func setupUserInterface() {
        setupNavigationBar(title: "")
        setupInformationScrollView()
        setupInformationTopImageView()
    }

    private func setupInformationScrollView() {

        // UIScrollViewに関する設定をする
        // NavigationBar分のスクロール位置がずれてしまわないようにする考慮は下記の通り:
        // 考慮する項目1. Information.storyboardにおいて「Adjust Scroll View Insets」のチェックを外す
        // 考慮する項目2. informationScrollViewのTopのAutoLayoutを「Information Scroll View.top = SafeArea.top」とする
        informationScrollView.delegate = self
    }

    private func setupInformationTopImageView() {

        // 初期状態時のトップ画像の高さや拡大モード等をを設定する
        informationTopImageView.contentMode = .scaleAspectFill
        informationTopImageHeightConstraint.constant = originalInformationTopImageHeight
    }

    // ドロップダウンメニューに関する初期設定をする
    private func initializeDropDownMenuDataLists(targetViewModel: InformationViewModel, targetTitles: [String]) {

        // ドロップダウンメニューに関して必要な初期設定をする(リスト表示の部分でViewModelを利用する)
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.index(0), items: targetTitles)
        self.navigationItem.titleView = menuView

        // ドロップダウンメニュー内のセルをタップした際は該当の情報を表示するためのViewModel側のメソッドを実行する
        menuView.didSelectItemAtIndexHandler = { (indexPath: Int) -> Void in
            targetViewModel.switchSelectedInformation(indexPath: indexPath)
        }
    }

    // ドロップダウンメニューに関するデザイン設定をする
    private func initializeDropDownMenuDecoration() {

        // 参考: セルの要素に関する設定
        menuView.cellHeight = 58
        menuView.cellBackgroundColor = .white
        menuView.cellSeparatorColor = UIColor(code: "#ccccc3")
        menuView.cellSelectionColor = UIColor(code: "#f7f7f7")
        menuView.cellTextLabelColor = .gray
        menuView.cellTextLabelFont = UIFont(name: AppConstant.COMMON_FONT_BOLD, size: AppConstant.COMMON_DROPDOWN_MENU_FONT_SIZE)
        menuView.cellTextLabelAlignment = .left
        menuView.shouldKeepSelectedCellColor = true

        // 参考: セルのアイコン表示に関する設定
        menuView.arrowPadding = 15
        menuView.checkMarkImage
            = UIImage.fontAwesomeIcon(name: .checkCircle, style: .solid, textColor: .gray, size: CGSize(width: 16.0, height: 16.0))

        // 参考: ナビゲーションバーのタイトル表示に関する設定
        menuView.navigationBarTitleFont = UIFont(name: AppConstant.COMMON_FONT_BOLD, size: AppConstant.COMMON_NAVIGATION_FONT_SIZE)

        // 参考: ドロップダウンメニュー表示に関する設定
        menuView.animationDuration = 0.24
        menuView.maskBackgroundColor = .black
        menuView.maskBackgroundOpacity = 0.72
    }

    // 受け取ったInformationModelの情報を表示する
    private func displayInformation(targetModel: InformationModel?) {
        if let model = targetModel {

            informationTopImageView.image = UIImage(named: model.imageName)
            informationTitleLabel.text = model.title

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            var attributes = [NSAttributedString.Key : Any]()
            attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            attributes[NSAttributedString.Key.font] = UIFont(name: AppConstant.COMMON_FONT_NORMAL, size: 14.0)
            attributes[NSAttributedString.Key.foregroundColor] = UIColor(code: "#333333")
            informationSummaryLabel.attributedText = NSAttributedString(string: model.summary, attributes: attributes)
        }
    }

    // JSONファイルで定義されたデータを読み込んでData型で返す
    private func getDataFromJSONFile() -> Data {
        if let path = Bundle.main.path(forResource: "information_datasources", ofType: "json") {
            return try! Data(contentsOf: URL(fileURLWithPath: path))
        } else {
            fatalError("Invalid json format or existence of file.")
        }
    }
}

// MARK: - UIScrollViewDelegate

extension InformationViewController: UIScrollViewDelegate {

    // スクロールが実行された際にトップ画像に視差効果を付与する
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        informationTopImageTopConstraint.constant = min(scrollView.contentOffset.y, 0)
        informationTopImageHeightConstraint.constant = max(0, originalInformationTopImageHeight - scrollView.contentOffset.y)
    }
}
