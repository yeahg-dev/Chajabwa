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
    
    func fetchSavedApps(
        in appFolder: AppFolder)
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
    
    func appendAppToSavedApps(
        _ app: SavedApp,
        in appFolder: AppFolder)
    async throws -> AppFolder
    {
        return try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                if let appFolderRealm = realm.object(
                    ofType: AppFolderRealm.self,
                    forPrimaryKey: appFolder.identifier) {
                    do {
                        let savedApp = SavedAppRealm(model: app)
                        try realm.write {
                            appFolderRealm.savedApps.append(savedApp)
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
    
    func deleteAppsAtSavedApps(
        _ app: [SavedApp],
        in appFolder: AppFolder)
    async throws -> AppFolder
    {
        return try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                if let appFolderRealm = realm.object(
                    ofType: AppFolderRealm.self,
                    forPrimaryKey: appFolder.identifier) {
                    do {
                        let indexsToDelete = app.compactMap {
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
    
}

enum RealmAppFolderRepositoryError: Error {
    
    case appFolderDTOFailure
    case appFolderCreationError
    case appFolderFetchError
    case appFolderUpdateError
    
}
