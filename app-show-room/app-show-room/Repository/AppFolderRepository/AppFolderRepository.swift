//
//  AppFolderRepository.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/10.
//

import Foundation

protocol AppFolderRepository {
    
    func fetch(identifier: String) async throws -> AppFolder
    
    func fetchAppFolders(
        of savedApp: SavedApp)
    async throws -> [AppFolder]
    
    func fetchSavedApp(_ appUnit: AppUnit) async -> SavedApp?
    
    func fetchSavedApps(
        from appFolder: AppFolder)
    async throws -> [SavedApp]
    
    func create(appFolder: AppFolder) async throws -> AppFolder
    
    func createSavedApp(
        _ appUnit: AppUnit,
        iconImageURL: String?)
    async -> SavedApp
    
    @discardableResult
    func updateName(
        with name: String,
        of appFolder: AppFolder)
    async throws -> AppFolder
    
    @discardableResult
    func updateDescription(
        with description: String,
        of appFolder: AppFolder)
    async throws -> AppFolder
    
    @discardableResult
    func append(
        _ savedApp: AppUnit,
        iconImageURL: String?,
        to appFolder: AppFolder)
    async throws -> AppFolder
    
    @discardableResult
    func delete(
        _ savedApps: [SavedApp],
        in appFolder: AppFolder)
    async throws -> AppFolder
    
    func updateAppFolder(
        of savedApp: SavedApp,
        to appFolder: [AppFolder])
    async throws -> SavedApp
    
}
