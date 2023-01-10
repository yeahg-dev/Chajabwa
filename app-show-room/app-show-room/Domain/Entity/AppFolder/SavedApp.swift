//
//  SavedApp.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/09.
//

import Foundation

struct SavedApp {
    
    let identifier: String
    
    let name: String
    let appID: Int
    let country: Country
    let platform: SoftwareType
    
    init(
        identifier: String = UUID().uuidString,
        name: String,
        appID: Int,
        country: Country,
        platform: SoftwareType
    ) {
        self.identifier = identifier
        self.name = name
        self.appID = appID
        self.country = country
        self.platform = platform
    }

}

extension SavedApp: Hashable {
    
    static func == (lhs: SavedApp, rhs: SavedApp) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
}
