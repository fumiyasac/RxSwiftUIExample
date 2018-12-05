//
//  InformationViewController.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/29.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class InformationViewController: UIViewController {

    private let originalInformationTopImageHeight: CGFloat = 240
    private let dropDownMenuItems = [
        "Information Topic 1",
        "Information Topic 2",
        "Information Topic 3",
        "Information Topic 4"
    ]

    private var menuView: BTNavigationDropdownMenu!
    
    @IBOutlet weak private var informationScrollView: UIScrollView!
    @IBOutlet weak private var informationTopImageView: UIImageView!

    // TOP画像において変更対象となるAutoLayoutの制約値
    @IBOutlet weak var informationTopImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var informationTopImageTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUserInterface()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)

        menuView.hide()
    }

    // MARK: - Private Function

    private func setupUserInterface() {
        setupNavigationBar(title: "")
        setupInformationScrollView()
        setupInformationTopImageView()
        setupDropDownMenuView()
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

    private func setupDropDownMenuView() {
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.index(0), items: dropDownMenuItems)

        menuView.checkMarkImage
            = UIImage.fontAwesomeIcon(name: .checkCircle, style: .solid, textColor: .white, size: CGSize(width: 16.0, height: 16.0))
        menuView.cellHeight = 58
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor(code: "#6a91c1")
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.white
        menuView.navigationBarTitleFont = UIFont(name: AppConstant.COMMON_FONT_BOLD, size: AppConstant.COMMON_NAVIGATION_FONT_SIZE)
        menuView.cellTextLabelFont = UIFont(name: AppConstant.COMMON_FONT_BOLD, size: 12.0)
        menuView.cellTextLabelAlignment = .left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.24
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.64
        menuView.didSelectItemAtIndexHandler = { (indexPath: Int) -> Void in
            print("Did select item at index: \(indexPath)")
        }
        
        self.navigationItem.titleView = menuView
    }
}

extension InformationViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        informationTopImageTopConstraint.constant = min(scrollView.contentOffset.y, 0)
        informationTopImageHeightConstraint.constant = max(0, originalInformationTopImageHeight - scrollView.contentOffset.y)
    }
}
