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
    let iconImageURL: String
    let isBelongedToFolder: Bool
    
    init(
        folderName: String,
        folderCount: Int,
        iconImageURL: String,
        isBelongedToFolder: Bool)
    {
        self.folderName = folderName
        self.folderCount = "(\(folderCount))"
        self.iconImageURL = iconImageURL
        self.isBelongedToFolder = isBelongedToFolder
    }
    
}
