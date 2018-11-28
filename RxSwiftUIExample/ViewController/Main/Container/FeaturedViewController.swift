//
//  FeaturedViewController.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/28.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout

class FeaturedViewController: UIViewController {

    private let featuredCellCount: Int = 5

    @IBOutlet weak private var featuredCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUserInterface()
    }

    // MARK: - Private Function

    private func setupUserInterface() {
        setupFeaturedCollectionView()
    }

    private func setupFeaturedCollectionView() {

        featuredCollectionView.delegate = self
        featuredCollectionView.dataSource = self
        featuredCollectionView.showsHorizontalScrollIndicator = true
        featuredCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        featuredCollectionView.registerCustomCell(FeaturedCollectionViewCell.self)

        // UICollectionViewに付与するアニメーションに関する設定
        let layout = AnimatedCollectionViewLayout()
        layout.animator = RotateInOutAttributesAnimator()
        layout.scrollDirection = .horizontal
        featuredCollectionView.collectionViewLayout = layout
    }
}


// MARK: - UICollectionViewDelegate

extension FeaturedViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource

extension FeaturedViewController: UICollectionViewDataSource {
    
    // 配置するセルの個数を設定する
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featuredCellCount
    }
    
    // 配置するセルの表示内容を設定する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: FeaturedCollectionViewCell.self, indexPath: indexPath)
        return cell
    }

    // セル押下時の処理内容を記載する
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO:
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeaturedViewController: UICollectionViewDelegateFlowLayout {

    // タブ用のセルにおける矩形サイズを設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return FeaturedCollectionViewCell.cellSize
    }
}


// MARK: - UIScrollViewDelegate

extension FeaturedViewController: UIScrollViewDelegate {

    // スクロールの減速が終了した際に実行される処理
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        moveToNearestVisibleCell()
    }

    // 表示されているセルの位置補正を行う
    private func moveToNearestVisibleCell() {

        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude

        // 現在のUICollectionViewにおける見えている部分のX座標を取得する
        let visibleCenterX = Float(featuredCollectionView.contentOffset.x + (featuredCollectionView.bounds.size.width / 2))

        // 配置されているセルの個数を元にスナップさせる位置を算出する
        // https://stackoverflow.com/questions/33855945/uicollectionview-snap-onto-cell-when-scrolling-horizontally
        let allCellCount = featuredCollectionView.visibleCells.count
        for i in 0..<allCellCount {
            let cell = featuredCollectionView.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenterX = Float(cell.frame.origin.x + cellWidth / 2)

            // 一番近い場所にあるインデックス値を取得する
            let distance: Float = fabsf(visibleCenterX - cellCenterX)
            if distance < closestDistance {
                closestDistance = distance
                if let indexPath = featuredCollectionView.indexPath(for: cell) {
                    closestCellIndex = indexPath.row
                }
            }
        }

        // インデックス値が負数でなければ移動する
        if closestCellIndex >= 0 {
            featuredCollectionView.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}

