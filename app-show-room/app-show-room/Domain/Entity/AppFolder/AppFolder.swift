//
//  AppFolder.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/09.
//

import Foundation

struct AppFolder {
    
    private let identifier: String
    private var savedApps: Set<SavedApp>
    private var name: String
    private var description: String
    private var icon: String
   
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
