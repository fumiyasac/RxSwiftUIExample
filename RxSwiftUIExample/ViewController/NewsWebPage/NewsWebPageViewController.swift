//
//  NewsWebPageViewController.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/30.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit
import WebKit
import Toast_Swift

import RxSwift
import RxCocoa

// MEMO: DeckTransitionを使用した表示ではスワイプが強いと戻ってしまう...
class NewsWebPageViewController: UIViewController {

    private let disposeBag = DisposeBag()

    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var headerBackgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // UIまわりの初期設定
        setupUserInterface()

        // 戻るボタンを押下した場合の処理
        closeButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showToastForAnnounce()
    }

    // MARK: - Function

    // MARK: - Private Function

    private func setupUserInterface() {
        setupNewsWebview()
    }
    
    private func setupNewsWebview() {

        // WKWebViewを作成する
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.allowsBackForwardNavigationGestures = true
        webView.backgroundColor = .white

        // WKWebViewを追加してし制約を付与する
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: headerBackgroundView.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            webView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            webView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
            webView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        } else {
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            webView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            webView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        }

        // TODO: 後で正しい形に直す
        if let url = URL(string: "https://www.yahoo.co.jp/") {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }

    private func showToastForAnnounce() {

        // TODO: 後で正しい形に直す
        let centerX: CGFloat = UIScreen.main.bounds.width / 2
        let centerY: CGFloat = 96.0
        let toastShowPoint = CGPoint(x: centerX, y: centerY)

        var style = ToastStyle()
        style.messageFont = UIFont(name: AppConstant.COMMON_FONT_BOLD, size: AppConstant.TOAST_FONT_SIZE)!
        style.messageColor = AppConstant.TOAST_TINT_COLOR
        style.messageAlignment = .center
        style.backgroundColor = UIColor(code: "#333333", alpha: 0.5)

        self.view.makeToast("This is Toast Example!", duration: 1.6, point: toastShowPoint, title: nil, image: nil, completion: nil)
    }
}
