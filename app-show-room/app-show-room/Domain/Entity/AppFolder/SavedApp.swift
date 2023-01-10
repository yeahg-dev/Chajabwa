//
//  SavedApp.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/09.
//

import Foundation

struct SavedApp {
    
    private let identifer: String
    
    private let name: String
    private let appID: Int
    private let country: Country
    private let platform: SoftwareType
    private var folders: Set<AppFolder>

}

extension SavedApp: Hashable {
    
    static func == (lhs: SavedApp, rhs: SavedApp) -> Bool {
        return lhs.identifer == rhs.identifer
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifer)
    }
    
}
