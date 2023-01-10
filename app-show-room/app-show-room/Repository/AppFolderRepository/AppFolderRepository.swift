//
//  AppFolderRepository.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/10.
//

import Foundation

protocol AppFolderRepository {
    
    func fetch(identifier: String) async throws -> AppFolder
    
    func fetchSavedApps(
        from appFolder: AppFolder)
    async throws -> [SavedApp]
    
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
    
    func append(
        _ savedApp: SavedApp,
        to appFolder: AppFolder)
    async throws -> AppFolder
    
    func delete(
        _ savedApps: [SavedApp],
        in appFolder: AppFolder)
    async throws -> AppFolder
    
}
