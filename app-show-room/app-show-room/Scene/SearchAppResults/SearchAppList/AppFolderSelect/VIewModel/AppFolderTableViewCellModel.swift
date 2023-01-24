//
//  AppFolderTableViewCellModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/16.
//

import Foundation

struct AppFolderTableViewCellModel {
    
    let folderName: String
    let folderCount: String
    let iconImageURL: String?
    var isBelongedToFolder: Bool
   
    init(appFolder: AppFolder, isSelectedAppFolder: Bool) {
        self.folderName = appFolder.name
        self.folderCount = "(\(appFolder.appCount))"
        self.iconImageURL = appFolder.iconImageURL
        self.isBelongedToFolder = isSelectedAppFolder
    }
    
}
