//
//  SavedApp.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/09.
//

import Foundation

struct SavedApp {
    
    let identifier: String
    let appUnit: AppUnit
    let iconImageURL: String?
    
    init(
        identifier: String = UUID().uuidString,
        appUnit: AppUnit,
        iconImageURL: String?
    ) {
        self.identifier = identifier
        self.appUnit = appUnit
        self.iconImageURL = iconImageURL
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
