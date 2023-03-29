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
    
    func fetchAllAppFolders() async -> [AppFolder] {
        await withCheckedContinuation{ continuation in
            realmQueue.async {
                let result = realm.objects(AppFolderRealm.self)
                continuation.resume(returning: result.map{$0.toDomain()!})
            }
        }
    }
    
    func fetchAppFolders(
        of savedApp: SavedApp)
    async -> [AppFolder]
    {
        await withCheckedContinuation{ continuation in
            realmQueue.async {
                guard let savedAppRealm = realm.object(
                    ofType: SavedAppRealm.self,
                    forPrimaryKey: savedApp.identifier) else {
                    continuation.resume(returning: [])
                    return
                }
                let appFolders = AnyCollection(savedAppRealm.folders.compactMap({ appFolderRealm in
                    appFolderRealm.toDomain()})).map { return $0 }
                continuation.resume(returning: appFolders)
            }
        }
    }
    
    func fetchSavedApp(_ appUnit: AppUnit) async -> SavedApp? {
        await withCheckedContinuation{ continuation in
            realmQueue.async {
                if let fetchedSaveapp = realm.objects(SavedAppRealm.self)
                    .where ({ savedApp in
                        savedApp.appID == appUnit.appID &&
                        savedApp.countryName == appUnit.country.name &&
                        savedApp.softwareTypeName == appUnit.platform.rawValue })
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
    
    @discardableResult
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
    
    @discardableResult
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
    
    @discardableResult
    func append(
        _ savedApp: AppUnit,
        iconImageURL: String?,
        to appFolder: AppFolder)
    async throws -> AppFolder
    {
        let app: SavedApp
        if let savedApp = await fetchSavedApp(savedApp) {
            app = savedApp
        } else {
            app = await createSavedApp(
                savedApp,
                iconImageURL: iconImageURL)
        }
    
        return try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                if let appFolderRealm = realm.object(
                    ofType: AppFolderRealm.self,
                    forPrimaryKey: appFolder.identifier),
                   let savedAppRealm = realm.object(
                    ofType: SavedAppRealm.self,
                    forPrimaryKey: app.identifier) {
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
    
    @discardableResult
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
    
    func deleteAppFolder(_ appFolder: AppFolder) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                if let appFolder = realm.object(ofType: AppFolderRealm.self, forPrimaryKey: appFolder.identifier) {
                      do {
                          try realm.write{
                              realm.delete(appFolder)
                          }
                          continuation.resume()
                      } catch {
                          print("failed in \(self): \(error)")
                          continuation.resume(throwing: RealmAppFolderRepositoryError.appFolderDeleteError)
                      }
                }
            }
        }
    }
    
    @discardableResult
    func createSavedApp(
        _ appUnit: AppUnit,
        iconImageURL: String?)
    async -> SavedApp
    {
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                let newSavedApp = SavedApp(
                    appUnit: appUnit,
                    iconImageURL: iconImageURL)
                let savedAppRealm = SavedAppRealm(model: newSavedApp)
                try! realm.write {
                    realm.add(savedAppRealm)
                }
                continuation.resume(returning: newSavedApp)
            }
        }
    }
    
    @discardableResult
    func updateAppFolder(
        of savedApp: SavedApp,
        to appFolder: [AppFolder])
    async throws -> SavedApp
    {
        try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                guard let savedAppRealm = realm.object(
                    ofType: SavedAppRealm.self,
                    forPrimaryKey: savedApp.identifier) else {
                    continuation.resume(throwing: RealmAppFolderRepositoryError.appFolderFetchError)
                    return
                }
                do {
                    try realm.write {
                        // 기존 소속 appFolder에서 자신을 제거
                        savedAppRealm.folders.forEach { appFolder in
                            if let indexToDelete = appFolder.savedApps.index(
                                matching: "identifier == %@", savedApp.identifier) {
                                appFolder.savedApps.remove(at: indexToDelete)
                            }
                        }
                        // 새로운 appFolder에 자신을 추가
                        appFolder.forEach { newAppFolder in
                            if let newAppFolderRealm = realm.object(
                                ofType: AppFolderRealm.self,
                                forPrimaryKey: newAppFolder.identifier){
                                newAppFolderRealm.savedApps.append(savedAppRealm)
                            }
                        }
                    }
                    continuation.resume(returning: savedAppRealm.toDomain()!)
                } catch {
                    continuation.resume(
                        throwing: RealmAppFolderRepositoryError.savedAppFolderUpdatingError)
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
    case appFolderDeleteError
    
    case savedAppFetchError
    case savedAppFolderUpdatingError
    
}
