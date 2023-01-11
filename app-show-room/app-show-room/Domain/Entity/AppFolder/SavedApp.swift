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
    
    init(
        identifier: String = UUID().uuidString,
        appUnit: AppUnit
    ) {
        self.identifier = identifier
        self.appUnit = appUnit
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
