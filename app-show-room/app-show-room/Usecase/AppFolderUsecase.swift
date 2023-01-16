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
    
    init(
        appFolderRepository: AppFolderRepository = RealmAppFolderRepository(
            realmStore: DefaultRealmStore()!))
    {
        self.appFolderRepository = appFolderRepository
    }
    
    func createEmptyAppFolder(
        name: String,
        description: String)
    async throws
    {
        try await appFolderRepository.create(
            appFolder: AppFolder(
                savedApps: [],
                name: name,
                description: description,
                iconImageURL: nil))
    }
    
    // textDidChange -> value -> @published Subject (Input) -> transform -> Output
    //                                              비즈니스 로직
    func validateAppFolderName(
        _ name: AnyPublisher<String, Never>)
    -> AnyPublisher<Bool, Never>
    {
        return name.map { $0.count > 1 }
            .eraseToAnyPublisher()
    }
    
    func readAllAppFolder() async -> [AppFolder] {
        await appFolderRepository.fetchAllAppFolders()
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
    
}
