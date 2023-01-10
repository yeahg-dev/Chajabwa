//
//  SavedAppRepository.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/10.
//

import Foundation

protocol SavedAppRepository {
    
    func updateAppFolder(
        with appFolders: [AppFolder])
    async throws -> SavedApp
    
}
