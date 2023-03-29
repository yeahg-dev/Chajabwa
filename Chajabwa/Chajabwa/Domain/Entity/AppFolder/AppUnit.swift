//
//  AppUnit.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/11.
//

import Foundation

struct AppUnit: Equatable {
    
    let name: String
    let appID: Int
    let searchingContury: Country
    let searchingPlatform: SoftwareType
    
}

extension AppUnit {
    
    static let placeholder = AppUnit(
        name: Texts.unable_to_download,
        appID: 0,
        searchingContury: Country.placeholder,
        searchingPlatform: SoftwareType.iPhone)
    
}
