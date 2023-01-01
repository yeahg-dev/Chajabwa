//
//  RecentSearchKeywordCellModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/01.
//

import UIKit

struct RecentSearchKeywordCellModel {
    
    let keyword: String
    let date: String
    let countryFlag: String
    let softwareIcon: UIImage?
    
    init(keyword: RecentSearchKeyword) {
        self.keyword = keyword.keyword
        self.date = keyword.date.formatted(date: .numeric, time: .omitted)
        self.countryFlag = keyword.configuration.country.flag
        self.softwareIcon = keyword.configuration.softwareType.iconImage
    }
    
}
