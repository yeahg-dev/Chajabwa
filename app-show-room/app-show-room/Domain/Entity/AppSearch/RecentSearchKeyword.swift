//
//  RecentSearchKeyword.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/29.
//

import Foundation

struct RecentSearchKeyword {
    
    let identifier: String
    let keyword: String
    let date: Date
    let configuration: SearchConfiguration
    
    init(
        keyword: String,
        date: Date,
        configuration: SearchConfiguration,
        identifier: String = UUID().uuidString)
    {
        self.keyword = keyword
        self.date = date
        self.configuration = configuration
        self.identifier = identifier
    }
    
}

struct SearchConfiguration {
    
    let country: Country
    let softwareType: SoftwareType
    
}
