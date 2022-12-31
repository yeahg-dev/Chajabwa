//
//  RecentSearchKeyword.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/29.
//

import Foundation

struct RecentSearchKeyword {
    
    let identifier = UUID()
    let keyword: String
    let date: Date
    let configuration: SearchConfiguration
    
}

struct SearchConfiguration {
    
    let country: Country
    let softwareType: SoftwareType
    
}
