//
//  AppFolder.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/09.
//

import Foundation

struct AppFolder {
    
    let identifier: String
    var savedApps: Set<SavedApp>
    var name: String
    var description: String?
    var iconImageURL: String?
   
    init(
        identifier: String = UUID().uuidString,
        savedApps: [SavedApp],
        name: String,
        description: String?,
        iconImageURL: String?)
    {
        self.identifier = identifier
        self.savedApps = Set(savedApps)
        self.name = name
        self.description = description
        self.iconImageURL = iconImageURL
    }
    
    var appCount: Int {
        return savedApps.count
    }
    
}

extension AppFolder: Hashable {

    static func == (lhs: AppFolder, rhs: AppFolder) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

}

extension AppFolder {
    
    static let placeholder = AppFolder(
        savedApps: [],
        name: Texts.unable_to_download,
        description: Texts.unable_to_download,
        iconImageURL: nil)
    
}
