//
//  SearchNewsTableViewCell.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/28.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit

class SearchNewsTableViewCell: UITableViewCell {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var digestLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupSearchNewsTableViewCell()
    }

    // MARK: - Function

    func setCell(_ model: SearchNewsModel)  {
        titleLabel.text  = model.newsTitle
        digestLabel.text = model.newsSnippet
    }

    // MARK: - Private Function

    private func setupSearchNewsTableViewCell() {
        self.accessoryType = .none
        self.selectionStyle = .none
    }
}
