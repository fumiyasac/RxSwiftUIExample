//
//  RecentNewsViewController.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/28.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit
import DeckTransition

import RxSwift
import RxCocoa

protocol RecentNewsViewControllerDelegate: NSObjectProtocol {

    // このViewControllerを表示するためのContainerViewの高さを更新する
    func updateContainerViewHeight(_ height: CGFloat)
}

class RecentNewsViewController: UIViewController {

    private let disposeBag = DisposeBag()

    // RecentNewsViewControllerDelegateの宣言
    weak var delegate: RecentNewsViewControllerDelegate?

    @IBOutlet weak private var recentNewsTableView: UITableView!
    @IBOutlet weak private var showNextPageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UIまわりの初期設定
        setupUserInterface()

        // ViewModelの初期化
        let recentNewsViewModel = RecentNewsViewModel(api: NewYorkTimesProductionAPI())

        // 初回表示分のニュースを取得する
        recentNewsViewModel.getRecentNews()

        // 次の10件を表示するボタンを押下した場合の処理
        showNextPageButton.rx.tap.asDriver().drive(onNext: { _ in
            recentNewsViewModel.getRecentNews()
        }).disposed(by: disposeBag)

        // UITableViewに配置されたセルをタップした場合の処理
        recentNewsTableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            let recentNews = recentNewsViewModel.recentNewsLists.value[indexPath.row]
            self?.showNewsWebPage(newsUrlString: recentNews.newsWebUrlString)
        }).disposed(by: disposeBag)

        // 一覧データをUITableViewにセットする処理
        recentNewsViewModel.recentNewsLists.asObservable().bind(to: recentNewsTableView.rx.items) { (tableView, row, model) in
            let cell = tableView.dequeueReusableCustomCell(with: RecentNewsTableViewCell.self)
            cell.setCell(model)
            return cell
        }.disposed(by: disposeBag)

        // 一覧データが追加された場合の処理
        recentNewsViewModel.recentNewsLists.asDriver().drive(onNext: { [weak self] in
            self?.updateRecentNewsTableViewHeightBy(dataCount: $0.count)
        }).disposed(by: disposeBag)

        // 読み込み状態が更新された場合の処理
        recentNewsViewModel.isLoading.asDriver().drive(onNext: { [weak self] in
            self?.updateshowNextPageButtonStatusBy(result: $0)
        }).disposed(by: disposeBag)

        // エラー状態が更新された場合の処理
        recentNewsViewModel.isError.asDriver().drive(onNext: { [weak self] in
            self?.showResponseErrorAlert(result: $0)
        }).disposed(by: disposeBag)
    }

    // MARK: - Private Function

    private func setupUserInterface() {
        setupRecentNewsTableView()
    }

    private func setupRecentNewsTableView() {
        recentNewsTableView.rowHeight = RecentNewsTableViewCell.cellHeight
        recentNewsTableView.delaysContentTouches = false
        recentNewsTableView.registerCustomCell(RecentNewsTableViewCell.self)
    }

    // 読み込みボタンの状態を更新する処理
    private func updateshowNextPageButtonStatusBy(result: Bool) {
        let buttonText = result ? "Now Loading ..." : "↓ More Next 10 News"
        self.showNextPageButton.setTitle(buttonText, for: .normal)
        self.showNextPageButton.isEnabled = !result
        self.showNextPageButton.alpha = result ? 0.3 : 1
    }

    // 親のViewControllerでContainerViewの高さ制約を更新する処理
    private func updateRecentNewsTableViewHeightBy(dataCount: Int) {
        let showNextPageButtonHeight = CGFloat(48.0)
        let allCellsHeight = CGFloat(dataCount) * RecentNewsTableViewCell.cellHeight
        let containerViewHeight = allCellsHeight + showNextPageButtonHeight
        self.delegate?.updateContainerViewHeight(containerViewHeight)
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
