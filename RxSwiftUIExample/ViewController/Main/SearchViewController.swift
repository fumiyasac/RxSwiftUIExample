//
//  SearchViewController.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/29.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    private var keywordSearchBar: KeywordSearchBar!
    private var tapGestureRecognizer : UITapGestureRecognizer!

    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUserInterface()
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
        keywordSearchBar = KeywordSearchBar()
        //keywordSearchBar.decorateSearchBar()
        keywordSearchBar.placeholder = "Please input keyword."
        keywordSearchBar.delegate = self

        self.navigationItem.titleView = keywordSearchBar
    }

    //
    private func setupSearchTableView() {
        
        //searchTableView.delegate = self
        //searchTableView.dataSource = self
        searchTableView.rowHeight = 48.0
        searchTableView.registerCustomCell(SearchNewsTableViewCell.self)

        // StatusBarのタップによるスクロールを防止する
        searchTableView.scrollsToTop = false

        // ボタンのタップとスクロールの競合を防止する
        searchTableView.delaysContentTouches = false

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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        //
        if let query = searchBar.text {
            print("検索文字列:", query)
        }
    }

    //
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
