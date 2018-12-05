//
//  InformationViewController.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/29.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    private let originalInformationTopImageHeight: CGFloat = 240

    @IBOutlet weak private var informationScrollView: UIScrollView!
    @IBOutlet weak private var informationTopImageView: UIImageView!

    // TOP画像において変更対象となるAutoLayoutの制約値
    @IBOutlet weak var informationTopImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var informationTopImageTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUserInterface()
    }

    // MARK: - Private Function

    private func setupUserInterface() {
        setupNavigationBar(title: "Information")
        setupInformationScrollView()
        setupInformationTopImageView()
    }

    private func setupInformationScrollView() {

        // NavigationBar分のスクロール位置がずれてしまう考慮を下記のように行う
        // 考慮する項目1. Information.storyboardにおいて「Adjust Scroll View Insets」のチェックを外す
        // 考慮する項目2. informationScrollViewのTopのAutoLayoutを「Information Scroll View.top = SafeArea.top」とする
        informationScrollView.delegate = self
    }

    private func setupInformationTopImageView() {
        informationTopImageHeightConstraint.constant = originalInformationTopImageHeight
    }
}

extension InformationViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        informationTopImageTopConstraint.constant = min(scrollView.contentOffset.y, 0)
        informationTopImageHeightConstraint.constant = max(0, originalInformationTopImageHeight - scrollView.contentOffset.y)
    }
}
