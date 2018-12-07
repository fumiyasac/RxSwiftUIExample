//
//  FeaturedViewController.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/28.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout

import RxSwift
import RxCocoa

class FeaturedViewController: UIViewController {

    private let disposeBag = DisposeBag()

    @IBOutlet weak private var featuredCollectionView: UICollectionView!
    @IBOutlet weak private var previousButton: UIButton!
    @IBOutlet weak private var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UIまわりの初期設定
        setupUserInterface()

        // ViewModelの初期化
        let featuredViewModel = FeaturedViewModel(data: getDataFromJSONFile())

        // RxSwiftでのUICollectionViewDelegateの宣言
        featuredCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

        // 次へボタンを押下した場合の処理
        nextButton.rx.tap.asDriver().drive(onNext: { _ in
            featuredViewModel.updateCurrentIndex(isIncrement: true)
        }).disposed(by: disposeBag)

        // 前へボタンを押下した場合の処理
        previousButton.rx.tap.asDriver().drive(onNext: { _ in
            featuredViewModel.updateCurrentIndex(isIncrement: false)
        }).disposed(by: disposeBag)

        // 一覧データをUICollectionViewにセットする処理
        featuredViewModel.featuredLists.bind(to: featuredCollectionView.rx.items) { (collectionView, row, model) in
            let cell = collectionView.dequeueReusableCustomCell(with: FeaturedCollectionViewCell.self, indexPath: IndexPath(row: row, section: 0))
            cell.setCell(model)
            return cell
        }.disposed(by: disposeBag)

        // 現在のインデックス値が変更された場合の処理
        featuredViewModel.currentIndex.asDriver().drive(onNext: { [weak self] in
            self?.featuredCollectionView.scrollToItem(at: IndexPath(row: $0, section: 0), at: .centeredHorizontally, animated: true)
        }).disposed(by: disposeBag)
        
        // 次へボタンの表示状態を決定する
        featuredViewModel.shouldHideNextButton.asDriver().drive(onNext: { [weak self] in
            self?.nextButton.isHidden = $0
        }).disposed(by: disposeBag)

        // 前へボタンの表示状態を決定する
        featuredViewModel.shouldHidePreviousButton.asDriver().drive(onNext: { [weak self] in
            self?.previousButton.isHidden = $0
        }).disposed(by: disposeBag)
    }

    // MARK: - Private Function

    private func setupUserInterface() {
        setupFeaturedCollectionView()
    }

    private func setupFeaturedCollectionView() {

        // UICollectionViewに関する初期設定
        featuredCollectionView.isScrollEnabled = false
        featuredCollectionView.showsHorizontalScrollIndicator = false
        featuredCollectionView.registerCustomCell(FeaturedCollectionViewCell.self)

        // UICollectionViewに付与するアニメーションに関する設定
        let layout = AnimatedCollectionViewLayout()
        layout.animator = CubeAttributesAnimator()
        layout.scrollDirection = .horizontal
        featuredCollectionView.collectionViewLayout = layout
    }

    // JSONファイルで定義されたデータを読み込んでData型で返す
    private func getDataFromJSONFile() -> Data {
        if let path = Bundle.main.path(forResource: "featured_datasources", ofType: "json") {
            return try! Data(contentsOf: URL(fileURLWithPath: path))
        } else {
            fatalError("Invalid json format or existence of file.")
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeaturedViewController: UICollectionViewDelegateFlowLayout {

    // タブ用のセルにおける矩形サイズを設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return FeaturedCollectionViewCell.cellSize
    }
}
