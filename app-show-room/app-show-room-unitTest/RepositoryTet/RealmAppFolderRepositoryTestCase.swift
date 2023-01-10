//
//  RealmAppFolderRepositoryTestCase.swift
//  app-show-room-unitTest
//
//  Created by Moon Yeji on 2023/01/10.
//

@testable import app_show_room
import XCTest

import RealmSwift

final class RealmAppFolderRepositoryTestCase: XCTestCase {
    
    private var sut: RealmAppFolderRepository!
    
    override func setUpWithError() throws {
        let configuration = Realm.Configuration(inMemoryIdentifier: self.name)
        let testRealmStore = TestRealmStore(configuration: configuration)
        sut = RealmAppFolderRepository(realmStore: testRealmStore)
    }

    func test_AppFolder를_생성하고_해당identifier로_fetch하면_object가_존재하는지()
    async throws
    {
        let targetAppFolder = DummyEntity.appFolder
        
        _ = try await sut.create(appFolder: targetAppFolder)
        let fetcheAppFolder = try await sut.fetch(identifier: targetAppFolder.identifier)
        
        XCTAssertEqual(targetAppFolder, fetcheAppFolder)
    }
    
    func test_AppFolder_name_update가_정상적으로되는지()
    async throws
    {
        let newName = "새로운 이름"
        let targetAppFolder = DummyEntity.appFolder
        
        let createdAppFolder = try await sut.create(appFolder: targetAppFolder)
        let updatedAppFolder = try await sut.updateName(
            with: newName,
            of: createdAppFolder)
        
        XCTAssertEqual(updatedAppFolder.name, newName)
    }
    
    func test_AppFolder_descrition_update가_정상적으로되는지()
    async throws
    {
        let newDescription = "새로운 설명"
        let targetAppFolder = DummyEntity.appFolder
        
        let createdAppFolder = try await sut.create(appFolder: targetAppFolder)
        let updatedAppFolder = try await sut.updateDescription(
            with: newDescription,
            of: createdAppFolder)
        
        XCTAssertEqual(updatedAppFolder.description, newDescription)
    }
    
    func test_AppFolder_icon_update가_정상적으로되는지()
    async throws
    {
        let newIcon = "✨"
        let targetAppFolder = DummyEntity.appFolder
        
        let createdAppFolder = try await sut.create(appFolder: targetAppFolder)
        let updatedAppFolder = try await sut.updateIcon(
            with: newIcon,
            of: createdAppFolder)
        
        XCTAssertEqual(updatedAppFolder.icon, newIcon)
    }
    
    func test_AppFolder에_SavedApp이_정상적으로_추가되는지()
    async throws
    {
        let targetAppFolder = DummyEntity.appFolder
        let dummySavedApp = DummyEntity.savedApp1
        
        let createdAppFolder = try await sut.create(appFolder: targetAppFolder)
        // MARK: - API 변경
        let updatedAppFolder = try await sut.appendAppToSavedApps(dummySavedApp, in: createdAppFolder)
        
        XCTAssertEqual(updatedAppFolder.appCount, 1)
        XCTAssertEqual(updatedAppFolder.savedApps.first?.name, dummySavedApp.name)
    }
    
    func test_AppFolder에_SavedApp3개가_정상적으로_추가되는지()
    async throws
    {
        let targetAppFolder = DummyEntity.appFolder
        let dummySavedApps = [DummyEntity.savedApp1, DummyEntity.savedApp2, DummyEntity.savedApp3]
        
        let createdAppFolder = try await sut.create(appFolder: targetAppFolder)
        // MARK: - API 변경
        for app in dummySavedApps {
            try await sut.appendAppToSavedApps(app, in: createdAppFolder)
        }
        let savedApps = try await sut.fetchSavedApps(in: createdAppFolder)
        
        XCTAssertEqual(savedApps, dummySavedApps)
    }
    
    func test_AppFolder에서_savedApp을_정상적으로_삭제하는지()
    async throws
    {
        let targetAppFolder = DummyEntity.appFolder
        let dummySavedApp = DummyEntity.savedApp1
        
        let createdAppFolder = try await sut.create(appFolder: targetAppFolder)
        // MARK: - API 변경
        let updatedAppFolder = try await sut.appendAppToSavedApps(dummySavedApp, in: createdAppFolder)
        let appFolderDeleted = try await sut.deleteAppsAtSavedApps(
            [dummySavedApp],
            in: updatedAppFolder)
        
        XCTAssertEqual(appFolderDeleted.appCount, 0)
    }

}

private enum DummyEntity {
    
    static let appFolder = AppFolder(
        savedApps: [],
        name: "테스트용 앱",
        description: "테스트 참고용",
        icon: "👩🏻‍🔬")
    
    static let savedApp1 = SavedApp(
        name: "앱과사전",
        appID: 9090,
        country: .init(name: "South Korea")!,
        platform: .iPhone)
    
    static let savedApp2 = SavedApp(
        name: "앱과사전",
        appID: 9090,
        country: .init(name: "South Korea")!,
        platform: .iPad)
    
    static let savedApp3 = SavedApp(
        name: "앱과사전",
        appID: 9090,
        country: .init(name: "South Korea")!,
        platform: .mac)
    
}
