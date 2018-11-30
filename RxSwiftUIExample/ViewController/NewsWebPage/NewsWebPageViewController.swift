//
//  NewsWebPageViewController.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/30.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit
import WebKit

// MEMO: DeckTransitionを使用した表示でスワイプが強いと戻ってしまう...
class NewsWebPageViewController: UIViewController {
    
    @IBOutlet weak private var headerBackgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUserInterface()
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
}
