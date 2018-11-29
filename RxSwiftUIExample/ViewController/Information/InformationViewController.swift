//
//  InformationViewController.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/29.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUserInterface()
    }

    // MARK: - Private Function

    private func setupUserInterface() {
        setupNavigationBar(title: "Information")
    }
}
