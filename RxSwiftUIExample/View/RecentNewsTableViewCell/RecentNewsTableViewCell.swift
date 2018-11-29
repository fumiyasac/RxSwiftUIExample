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

    // MARK: - Private Function

    private func setupRecentNewsTableViewCell() {
        self.accessoryType = .none
        self.selectionStyle = .none
    }
}
