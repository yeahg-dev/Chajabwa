//
//  ReammAppFolderRepository.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/10.
//

import Foundation

import RealmSwift

struct RealmAppFolderRepository: AppFolderRepository {
    
    private let realm: Realm
    private let realmQueue: DispatchQueue
    
    init(realmStore: RealmStore) {
        self.realm = realmStore.realm
        self.realmQueue = realmStore.serialQueue
        print("📂\(self)'s file URL : \(realm.configuration.fileURL)")
    }
    
    func fetch(identifier: String) async throws -> AppFolder {
        try await withCheckedThrowingContinuation{ continuation in
            realmQueue.async {
                guard let result = realm.object(
                    ofType: AppFolderRealm.self,
                    forPrimaryKey: identifier) else {
                    print("failed in \(self): \(RealmAppFolderRepositoryError.appFolderFetchError)")
                    continuation.resume(
                        throwing: RealmAppFolderRepositoryError.appFolderFetchError)
                    return
                }
                continuation.resume(returning: result.toDomain()!)
            }
        }
    }
    
    func fetchSavedApp(
        name: String,
        id: Int,
        country: Country,
        platform: SoftwareType)
    async -> SavedApp?
    {
        await withCheckedContinuation{ continuation in
            realmQueue.async {
                if let fetchedSaveapp = realm.objects(SavedAppRealm.self)
                    .where ({ savedApp in
                        savedApp.appID == id && savedApp.countryName == country.name && savedApp.softwareTypeName == platform.rawValue })
                        .first {
                    continuation.resume(returning: fetchedSaveapp.toDomain())
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    func fetchSavedApps(
        from appFolder: AppFolder)
    async throws -> [SavedApp]
    {
        try await withCheckedThrowingContinuation{ continuation in
            realmQueue.async {
                guard let result = realm.object(
                    ofType: AppFolderRealm.self,
                    forPrimaryKey: appFolder.identifier) else {
                    print("failed in \(self): \(RealmAppFolderRepositoryError.appFolderFetchError)")
                    continuation.resume(
                        throwing: RealmAppFolderRepositoryError.appFolderFetchError)
                    return
                }
                continuation.resume(
                    returning: result.savedApps.compactMap{$0.toDomain()})
            }
        }
    }
    
    func create(
        appFolder: AppFolder)
    async throws -> AppFolder
    {
        try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                let appFolderRealm = AppFolderRealm(model: appFolder)
                do {
                    try realm.write {
                        realm.add(appFolderRealm)
                    }
                    continuation.resume(returning: appFolder)
                } catch {
                    print("failed in \(self): \(error)")
                    continuation.resume(throwing: RealmAppFolderRepositoryError.appFolderCreationError)
                }
            }
        }
    }
    
    func updateName(
        with name: String,
        of appFolder: AppFolder)
    async throws -> AppFolder
    {
        return try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                if let appFolderRealm = realm.object(
                    ofType: AppFolderRealm.self,
                    forPrimaryKey: appFolder.identifier) {
                    do {
                        try realm.write {
                            appFolderRealm.name = name
                        }
                        continuation.resume(returning: appFolderRealm.toDomain()!)
                    } catch {
                        continuation.resume(
                            throwing: RealmAppFolderRepositoryError.appFolderUpdateError)
                    }
                } else {
                    continuation.resume(throwing: RealmAppFolderRepositoryError.appFolderFetchError)
                }
                
            }
        }
    }
    
    func updateDescription(
        with description: String,
        of appFolder: AppFolder)
    async throws -> AppFolder
    {
        return try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                if let appFolderRealm = realm.object(
                    ofType: AppFolderRealm.self,
                    forPrimaryKey: appFolder.identifier) {
                    do {
                        try realm.write {
                            appFolderRealm.folderDescription = description
                        }
                        continuation.resume(returning: appFolderRealm.toDomain()!)
                    } catch {
                        continuation.resume(
                            throwing: RealmAppFolderRepositoryError.appFolderUpdateError)
                    }
                } else {
                    continuation.resume(throwing: RealmAppFolderRepositoryError.appFolderFetchError)
                }
                
            }
        }
    }
    
    func updateIcon(
        with icon: String,
        of appFolder: AppFolder)
    async throws -> AppFolder
    {
        return try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                if let appFolderRealm = realm.object(
                    ofType: AppFolderRealm.self,
                    forPrimaryKey: appFolder.identifier) {
                    do {
                        try realm.write {
                            appFolderRealm.icon = icon
                        }
                        continuation.resume(returning: appFolderRealm.toDomain()!)
                    } catch {
                        continuation.resume(
                            throwing: RealmAppFolderRepositoryError.appFolderUpdateError)
                    }
                } else {
                    continuation.resume(throwing: RealmAppFolderRepositoryError.appFolderFetchError)
                }
                
            }
        }
    }
    
    func append(
        _ savedApp: SavedApp,
        to appFolder: AppFolder)
    async throws -> AppFolder
    {
        let fetchedSavedApp = await createSavedApp(savedApp)
        
        return try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                if let appFolderRealm = realm.object(
                    ofType: AppFolderRealm.self,
                    forPrimaryKey: appFolder.identifier),
                   let savedAppRealm = realm.object(
                    ofType: SavedAppRealm.self,
                    forPrimaryKey: fetchedSavedApp.identifier) {
                    do {
                        try realm.write {
                            appFolderRealm.savedApps.append(savedAppRealm)
                        }
                        continuation.resume(returning: appFolderRealm.toDomain()!)
                    } catch {
                        continuation.resume(
                            throwing: RealmAppFolderRepositoryError.appFolderUpdateError)
                    }
                } else {
                    continuation.resume(throwing: RealmAppFolderRepositoryError.appFolderFetchError)
                }
                
            }
        }
    }
    
    func delete(
        _ savedApps: [SavedApp],
        in appFolder: AppFolder)
    async throws -> AppFolder
    {
        return try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                if let appFolderRealm = realm.object(
                    ofType: AppFolderRealm.self,
                    forPrimaryKey: appFolder.identifier) {
                    do {
                        let indexsToDelete = savedApps.compactMap {
                            appFolderRealm.savedApps.index(matching: "identifier == %@", $0.identifier) }
                        let indexSetToDelete = IndexSet(indexsToDelete)
                        try realm.write {
                            appFolderRealm.savedApps.remove(atOffsets: indexSetToDelete)
                        }
                        continuation.resume(returning: appFolderRealm.toDomain()!)
                    } catch {
                        continuation.resume(
                            throwing: RealmAppFolderRepositoryError.appFolderUpdateError)
                    }
                } else {
                    continuation.resume(throwing: RealmAppFolderRepositoryError.appFolderFetchError)
                }
                
            }
        }
    }
    
    private func createSavedApp(
        _ savedApp: SavedApp)
    async -> SavedApp
    {
        if let savedApp = await fetchSavedApp(
            name: savedApp.name,
            id: savedApp.appID,
            country: savedApp.country,
            platform: savedApp.platform) {
            return savedApp
        }
        
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                let savedAppRealm = SavedAppRealm(model: savedApp)
                try! realm.write {
                    realm.add(savedAppRealm)
                }
                continuation.resume(returning: savedApp)
            }
        }
    }
    
}

enum RealmAppFolderRepositoryError: Error {
    
    case appFolderDTOFailure
    case appFolderCreationError
    case appFolderFetchError
    case appFolderUpdateError
    
}
