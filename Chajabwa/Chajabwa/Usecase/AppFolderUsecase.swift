//
//  AppFolderUsecase.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/16.
//

import Combine
import Foundation

struct AppFolderUsecase {
    
    private let appFolderRepository: AppFolderRepository
    private let appDetailRepository = ItunesAppDetailRepository()
    
    init(
        appFolderRepository: AppFolderRepository = RealmAppFolderRepository(
            realmStore: DefaultRealmStore()!))
    {
        self.appFolderRepository = appFolderRepository
    }
    
    func createEmptyAppFolder(
        name: String,
        description: String?)
    async throws -> AppFolder
    {
        try await appFolderRepository.create(
            appFolder: AppFolder(
                savedApps: [],
                name: name,
                description: description,
                iconImageURL: nil))
    }
    
    func validateAppFolderName(
        _ name: String?)
    -> Bool
    {
        guard let name else {
            return false
        }
        return name.count > 1
    }
    
    func canSaveAppFolder(with appFolderCount: Int) -> Bool {
        return appFolderCount > 0
    }
    
    func readAppFolder(identifer: String) async throws -> AppFolder {
        return try await appFolderRepository.fetch(identifier: identifer)
    }
    
    func readAllAppFolder() async -> [AppFolder] {
        await appFolderRepository.fetchAllAppFolders()
    }
    
    func readSavedApps(of appFolder: AppFolder) async throws -> [SavedApp] {
        return try await appFolderRepository.fetchSavedApps(from: appFolder)
    }
    
    func readAppFolders(
        of appUnit: AppUnit)
    async -> [AppFolder] {
        guard let savedApp = await appFolderRepository.fetchSavedApp(appUnit) else {
            return []
        }
        return await appFolderRepository.fetchAppFolders(of: savedApp)
    }
    
    func append(
        appUnit: AppUnit,
        iconImageURL: String?,
        to appFolder: AppFolder)
    async throws -> AppFolder
    {
        try await appFolderRepository.append(
            appUnit,
            iconImageURL: iconImageURL,
            to: appFolder)
    }
    
    @discardableResult
    func updateAppFolder(
        _ appFolder: AppFolder,
        name: String,
        description: String)
    async throws -> AppFolder {
        try await appFolderRepository.updateName(with: name, of: appFolder)
        return try await appFolderRepository.updateDescription(
            with: description,
            of: appFolder)
    }
    
    func updateAppFolder(
        of appUnit: AppUnit,
        iconImageURL: String?,
        to appFolder: [AppFolder])
    async throws -> SavedApp {
        let savedApp = await appFolderRepository.createSavedApp(
            appUnit,
            iconImageURL: iconImageURL)
        return try await appFolderRepository.updateAppFolder(
            of: savedApp,
            to: appFolder)
    }
    
    func readSavedAppDetail(
        of savedApp: SavedApp)
    -> AnyPublisher<SavedAppDetail, Error>
    {
        return appDetailRepository.fetchAppDetail(
            of: savedApp.appUnit.appID,
            country: savedApp.appUnit.searchingContury,
            software: savedApp.appUnit.searchingPlatform)
        .map { appDetail in
            return SavedAppDetail(appDetail: appDetail, appUnit: savedApp.appUnit) }
        .eraseToAnyPublisher()
    }
    
    func readAppDetail(
        of savedApp: SavedApp)
    -> AnyPublisher<AppDetail, Error>
    {
        return appDetailRepository.fetchAppDetail(
            of: savedApp.appUnit.appID,
            country: savedApp.appUnit.searchingContury,
            software: savedApp.appUnit.searchingPlatform)
        .eraseToAnyPublisher()
    }
    
    func deleteAppFolder(_ appFolder: AppFolder) async throws {
        try await appFolderRepository.deleteAppFolder(appFolder)
    }
    
    func delete(
        _ savedApps: [SavedApp],
        in appFolder: AppFolder)
    async throws -> AppFolder {
        try await appFolderRepository.delete(
            savedApps,
            in: appFolder)
    }
    
}
