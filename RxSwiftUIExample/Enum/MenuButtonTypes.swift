//
//  MenuButtonTypes.swift
//  RxSwiftUIExample
//
//  Created by 酒井文也 on 2018/11/28.
//  Copyright © 2018 酒井文也. All rights reserved.
//

import Foundation
import FontAwesome_swift

enum MenuButtonTypes: CaseIterable {
    case search
    case information

    // MARK: -  Function

    func getStoryboardName() -> String {
        switch self {
        case .search:
            return "Search"
        case .information:
            return "Information"
        }
    }

    func getFontAwesomeIcon() -> FontAwesome {
        switch self {
        case .search:
            return .search
        case .information:
            return .infoCircle
        }
    }

    func getButtonName() -> String {
        switch self {
        case .search:
            return "Search News for Keyword"
        case .information:
            return "View Information"
        }
    }
}
