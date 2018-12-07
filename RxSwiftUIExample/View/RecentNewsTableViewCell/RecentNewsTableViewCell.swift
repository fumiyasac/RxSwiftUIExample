//
//  RecentNewsTableViewCell.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/28.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit

class RecentNewsTableViewCell: UITableViewCell {

    static let cellHeight: CGFloat = 70.0

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var byLineLabel: UILabel!
    @IBOutlet weak private var iconImageView: UIImageView!

    // MARK: - Initializer

    override func awakeFromNib() {
        super.awakeFromNib()

        setupRecentNewsTableViewCell()
    }

    // MARK: - Function
    
    func setCell(_ model: RecentNewsModel)  {
        titleLabel.text  = model.newsTitle
        byLineLabel.text = model.newsByLine
        dateLabel.text   = model.newsDate
    }

    // MARK: - Private Function

    private func setupRecentNewsTableViewCell() {
        self.accessoryType  = .none
        self.selectionStyle = .none
        iconImageView.image = UIImage.fontAwesomeIcon(name: .image, style: .solid, textColor: .gray, size: CGSize(width: 36.0, height: 36.0))
    }
}
