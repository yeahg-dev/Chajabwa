//
//  AppFolder.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/09.
//

import Foundation

struct AppFolder {
    
    var name: String
    var apps: [SavedApp]
    var description: String
    var icon: String
   
    var appCount: Int {
        return apps.count
    }
    
}
