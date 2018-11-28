//
//  RecentNewsViewController.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/28.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit

class RecentNewsViewController: UIViewController {
    
    @IBOutlet weak private var recentNewsTableViewCell: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUserInterface()
    }

    // MARK: - Private Function

    private func setupUserInterface() {
        setupRecentNewsTableView()
    }

    private func setupRecentNewsTableView() {
        recentNewsTableViewCell.delegate = self
        recentNewsTableViewCell.dataSource = self
        recentNewsTableViewCell.rowHeight = RecentNewsTableViewCell.cellHeight
        recentNewsTableViewCell.delaysContentTouches = false
        recentNewsTableViewCell.registerCustomCell(RecentNewsTableViewCell.self)
    }
}

// MARK: - UITableViewDelegate

extension RecentNewsViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension RecentNewsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: RecentNewsTableViewCell.self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO:
    }
}
