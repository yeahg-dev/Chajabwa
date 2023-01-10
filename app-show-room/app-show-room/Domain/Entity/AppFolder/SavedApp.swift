//
//  SavedApp.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/09.
//

import Foundation

struct SavedApp {
    
    private let identifier: String
    
    private let name: String
    private let appID: Int
    private let country: Country
    private let platform: SoftwareType
    private var folders: Set<AppFolder>
    
    init(
        identifier: String = UUID().uuidString,
        name: String,
        appID: Int,
        country: Country,
        platform: SoftwareType,
        folders: [AppFolder]
    ) {
        self.identifier = identifier
        self.name = name
        self.appID = appID
        self.country = country
        self.platform = platform
        self.folders = Set(folders)
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
