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
    private var keywordSearchBar: KeywordSearchBar!

    @IBOutlet weak private var searchTableView: UITableView!

    // 検索ボックスの値変化を監視対象にする（テキストが空っぽの場合はデータ取得を行わない）
    private var searchBarText: Observable<String> {

        // MEMO: 3文字未満のキーワードの場合は受け付けない & APIリクエストの際に0.5秒のバッファを持たせる
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

        // ViewModelの初期化
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

        // 読み込み状態が更新された場合の処理
        searchNewsViewModel.isLoading.asDriver().drive(onNext: { [weak self] in
            self?.searchTableView.isUserInteractionEnabled = !$0
        }).disposed(by: disposeBag)
        
        // エラー状態が更新された場合の処理
        searchNewsViewModel.isError.asDriver().drive(onNext: { [weak self] in
            self?.showResponseErrorAlert(result: $0)
        }).disposed(by: disposeBag)

        // 検索すべき入力テキストが決定された際に実行する
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
        setupNavigationBar(title: "")
        setupKeywordSearchBar()
        setupSearchTableView()
    }

    private func setupKeywordSearchBar() {

        // キーボード表示時にUITableViewのタップ処理をさせないためにUITapGestureRecognizerを作成する
        tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(searchBarUnforcus))
        tapGestureRecognizer.delegate = self

        // NavigationBarに設置するSearchBarを作成する
        keywordSearchBar = KeywordSearchBar()
        keywordSearchBar.placeholder = "Please input keyword."
        keywordSearchBar.delegate = self

        self.navigationItem.titleView = keywordSearchBar
    }

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

    // UITableViewのスクロール処理を実行した場合にはSearchBarのフォーカスを外す
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBarUnforcus()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SearchViewController : UIGestureRecognizerDelegate {

    // キーボード表示時にUITableViewのタップ処理をさせないためにUITapGestureRecognizerを有効にする
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}

// MARK: - UISearchBarDelegate


extension SearchViewController: UISearchBarDelegate {

    // SearchBarでの入力を開始した場合は、キャンセルボタンをセットしてUITapGestureRecognizerを付与する
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        self.view.addGestureRecognizer(tapGestureRecognizer)
        return true
    }

    // SearchBarでの入力を終了した場合は、キャンセルボタンをキャンセルしてUITapGestureRecognizerを削除する
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        self.view.removeGestureRecognizer(tapGestureRecognizer)
        return true
    }

    // キャンセルボタンをタップした場合は、キーボードを隠す
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

