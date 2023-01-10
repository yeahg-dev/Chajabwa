//
//  AppFolderRepository.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/10.
//

import Foundation

protocol AppFolderRepository {
    
    func create(appFolder: AppFolder) async throws -> AppFolder
    
    func updateName(
        with name: String,
        of appFolder: AppFolder)
    async throws -> AppFolder
    
    func updateDescription(
        with description: String,
        of appFolder: AppFolder)
    async throws -> AppFolder
    
    func updateIcon(
        with icon: String,
        of appFolder: AppFolder)
    async throws -> AppFolder
    
    func appendAppToSavedApps(
        _ app: SavedApp,
        in appFolder: AppFolder)
    async throws -> AppFolder
    
    func deleteAppsAtSavedApps(
        _ app: [SavedApp],
        in appFolder: AppFolder)
    async throws -> AppFolder
    
}
