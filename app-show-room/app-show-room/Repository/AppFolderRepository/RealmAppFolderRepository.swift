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
        let appFolderRealm = try await fetchAppFolderRealm(with: appFolder.identifier)
        return try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                do {
                    try realm.write {
                        appFolderRealm.name = name
                    }
                    continuation.resume(returning: appFolderRealm.toDomain()!)
                } catch {
                    continuation.resume(
                        throwing: RealmAppFolderRepositoryError.appFolderUpdateError)
                }
            }
        }
    }
    
    func updateDescription(
        with description: String,
        of appFolder: AppFolder)
    async throws -> AppFolder
    {
        let appFolderRealm = try await fetchAppFolderRealm(with: appFolder.identifier)
        return try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                do {
                    try realm.write {
                        appFolderRealm.folderDescription = description
                    }
                    continuation.resume(returning: appFolderRealm.toDomain()!)
                } catch {
                    continuation.resume(
                        throwing: RealmAppFolderRepositoryError.appFolderUpdateError)
                }
            }
        }
    }
    
    func updateIcon(
        with icon: String,
        of appFolder: AppFolder)
    async throws -> AppFolder
    {
        let appFolderRealm = try await fetchAppFolderRealm(with: appFolder.identifier)
        return try await withCheckedThrowingContinuation{ continuation in
            realmQueue.async {
                do {
                    try realm.write {
                        appFolderRealm.icon = icon
                    }
                    continuation.resume(returning: appFolderRealm.toDomain()!)
                } catch {
                    continuation.resume(
                        throwing: RealmAppFolderRepositoryError.appFolderUpdateError)
                }
            }
        }
    }
    
    func appendAppToSavedApps(
        _ app: SavedApp,
        in appFolder: AppFolder)
    async throws -> AppFolder
    {
        let appFolderRealm = try await fetchAppFolderRealm(with: appFolder.identifier)
        return try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
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
            }
        }
    }
    
    func deleteAppsAtSavedApps(
        _ app: [SavedApp],
        in appFolder: AppFolder)
    async throws -> AppFolder
    {
        let appFolderRealm = try await fetchAppFolderRealm(with: appFolder.identifier)
        return try await withCheckedThrowingContinuation{ continuation in
            realmQueue.async {
                do {
                    let indexsToDelete = app.compactMap { savedApp in
                        appFolderRealm.savedApps.index(matching: "identifier == %@", savedApp.identifier)
                    }
                    let indexSetToDelete = IndexSet(indexsToDelete)
                    try realm.write {
                        appFolderRealm.savedApps.remove(atOffsets: indexSetToDelete)
                    }
                    continuation.resume(returning: appFolderRealm.toDomain()!)
                } catch {
                    continuation.resume(
                        throwing: RealmAppFolderRepositoryError.appFolderUpdateError)
                }
            }
        }
    }
    
    private func fetchAppFolderRealm(
        with identifier: String)
    async throws -> AppFolderRealm
    {
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
                continuation.resume(returning: result)
            }
        }
    }
    
}

enum RealmAppFolderRepositoryError: Error {
    
    case appFolderCreationError
    case appFolderFetchError
    case appFolderUpdateError
}
