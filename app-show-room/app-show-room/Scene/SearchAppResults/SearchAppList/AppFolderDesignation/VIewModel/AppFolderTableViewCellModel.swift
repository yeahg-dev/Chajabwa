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
    
    init(
        folderName: String,
        folderCount: Int,
        iconImageURL: String)
    {
        self.folderName = folderName
        self.folderCount = "(\(folderCount))"
        self.iconImageURL = iconImageURL
    }
    
}
