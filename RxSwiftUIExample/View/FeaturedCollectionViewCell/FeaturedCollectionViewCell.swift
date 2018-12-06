//
//  FeaturedCollectionViewCell.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/28.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit

class FeaturedCollectionViewCell: UICollectionViewCell {

    static let cellSize: CGSize = {
        let cellWidth = UIScreen.main.bounds.width
        let cellHeight = CGFloat(180.0)
        return CGSize(width: cellWidth, height: cellHeight)
    }()

    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!

    // MARK: - Function

    func setCell(_ model: FeaturedModel)  {
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.image = UIImage(named: model.imageName)
        titleLabel.text = model.title
    }
}
