//
//  SearchViewController.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/29.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit
import DeckTransition

import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private var tapGestureRecognizer: UITapGestureRecognizer!

    @IBOutlet weak private var keywordSearchBar: KeywordSearchBar!
    @IBOutlet weak private var searchTableView: UITableView!

    // 検索ボックスの値変化を監視対象にする（テキストが空っぽの場合はデータ取得を行わない）
    private var searchBarText: Observable<String> {

        // MEMO: 0.5秒のバッファを持たせる
        return keywordSearchBar.rx.text
            .filter { $0 != nil }
            .map { $0! }
            .filter { $0.count >= 3 }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // UIまわりの初期設定
        setupUserInterface()

        //
        let searchNewsViewModel = SearchNewsViewModel(api: NewYorkTimesProductionAPI())

        // RxSwiftでのUICollectionViewDelegateの宣言
        searchTableView.rx.setDelegate(self).disposed(by: disposeBag)

        // UITableViewに配置されたセルをタップした場合の処理
        searchTableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            let searchNews = searchNewsViewModel.searchNewsLists.value[indexPath.row]
            self?.showNewsWebPage(newsUrlString: searchNews.newsWebUrlString)
        }).disposed(by: disposeBag)

        // 一覧データをUITableViewにセットする処理
        searchNewsViewModel.searchNewsLists.asObservable().bind(to: searchTableView.rx.items) { (tableView, row, model) in
            let cell = tableView.dequeueReusableCustomCell(with: SearchNewsTableViewCell.self)
            cell.setCell(model)
            return cell
        }.disposed(by: disposeBag)

        //
        searchBarText.subscribe(onNext: {
            searchNewsViewModel.getSearchNews(keyword: $0)
        }).disposed(by: disposeBag)

    }

    // MARK: - Private Function

    // スクロールすると検索フォームのフォーカスを外す
    @objc private func searchBarUnforcus() {
        keywordSearchBar.resignFirstResponder()
    }

    private func setupUserInterface() {
        setupNavigationBar(title: "Search News")
        setupKeywordSearchBar()
        setupSearchTableView()
    }

    //
    private func setupKeywordSearchBar() {

        //
        tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(searchBarUnforcus))
        tapGestureRecognizer.delegate = self

        //
        keywordSearchBar.placeholder = "Please input keyword."
        keywordSearchBar.delegate = self
    }

    //
    private func setupSearchTableView() {

        // UITableViewの初期設定をする
        searchTableView.rowHeight = 60.0
        searchTableView.registerCustomCell(SearchNewsTableViewCell.self)

        // StatusBarのタップによるスクロールを防止する
        searchTableView.scrollsToTop = false

        // ボタンのタップとスクロールの競合を防止する
        searchTableView.delaysContentTouches = false
    }

    // ニュースの詳細をWebviewで表示する処理
    private func showNewsWebPage(newsUrlString: String) {
        let sb = UIStoryboard(name: "NewsWebPage", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! NewsWebPageViewController
        let delegate = DeckTransitioningDelegate()
        vc.setSelectedNewsUrlString(targetNewsUrlString: newsUrlString)
        vc.transitioningDelegate = delegate
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
    }

    // エラー時のアラートを表示する処理
    private func showResponseErrorAlert(result: Bool) {
        if result {
            let errorTitle = "Error Occured!"
            let errorMessage = "New York Times API Response Error. Please try again."
            showAlertWith(title: errorTitle, message: errorMessage)
        }
    }

    private func showAlertWith(title: String, message: String, completionHandler: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler?()
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate

extension SearchViewController: UIScrollViewDelegate {

    //
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBarUnforcus()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SearchViewController : UIGestureRecognizerDelegate {

    //
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}

// MARK: - UISearchBarDelegate


extension SearchViewController: UISearchBarDelegate {

    //
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {

        //
        searchBar.setShowsCancelButton(true, animated: true)
        self.view.addGestureRecognizer(tapGestureRecognizer)
        return true
    }

    //
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {

        //
        searchBar.setShowsCancelButton(false, animated: true)
        self.view.removeGestureRecognizer(tapGestureRecognizer)
        return true
    }

    //
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

