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
        let dummyAppUnit = DummyEntity.appUnit1
        
        let createdAppFolder = try await sut.create(appFolder: targetAppFolder)
        // MARK: - API 변경
        let updatedAppFolder = try await sut.append(
            dummyAppUnit,
            to: createdAppFolder)
        
        XCTAssertEqual(updatedAppFolder.appCount, 1)
        XCTAssertEqual(updatedAppFolder.savedApps.first!.appUnit, dummyAppUnit)
    }
    
    func test_AppFolder에_SavedApp3개가_정상적으로_추가되는지()
    async throws
    {
        let targetAppFolder = DummyEntity.appFolder
        let dummyAppUnits = [DummyEntity.appUnit1,
                              DummyEntity.appUnit2,
                              DummyEntity.appUnit3]
        
        let createdAppFolder = try await sut.create(appFolder: targetAppFolder)
        for app in dummyAppUnits {
            try await sut.append(app, to: createdAppFolder)
        }
        let savedApps = try await sut.fetchSavedApps(from: createdAppFolder)
        
        XCTAssertEqual(savedApps.map{$0.appUnit}, dummyAppUnits)
    }
    
    func test_AppFolder에서_savedApp을_정상적으로_삭제하는지()
    async throws
    {
        let targetAppFolder = DummyEntity.appFolder
        let dummySavedAppUnit = DummyEntity.appUnit1
        
        let createdAppFolder = try await sut.create(appFolder: targetAppFolder)
        let updatedAppFolder = try await sut.append(
            dummySavedAppUnit,
            to: createdAppFolder)
        if let savedApp = await sut.fetchSavedApp(dummySavedAppUnit) {
            let appFolderDeleted = try await sut.delete(
                [savedApp],
                in: updatedAppFolder)
            XCTAssertEqual(appFolderDeleted.appCount, 0)
        } else {
            print("Failed to fetch SavedApp")
        }
      
    }
    
    func test_AppFolder에_savedApp을_추가한뒤_SavedApp이_fetch되는지()
    async throws
    {
        let dummyAppFolder = DummyEntity.appFolder
        let dummyAppUnit = DummyEntity.appUnit1
        
        let createdAppFolder = try await sut.create(
            appFolder: dummyAppFolder)
        try await sut.append(dummyAppUnit, to: createdAppFolder)
        if let savedApp = await sut.fetchSavedApp(dummyAppUnit) {
            XCTAssertEqual(savedApp.appUnit, dummyAppUnit)
        } else {
            XCTFail("Failed To fetch SavedApp")
        }
    }
    
}

private enum DummyEntity {
    
    static let appFolder = AppFolder(
        savedApps: [],
        name: "테스트용 앱",
        description: "테스트 참고용",
        icon: "👩🏻‍🔬")
    
    static let appUnit1 = AppUnit(
        name: "앱과사전",
        appID: 9090,
        country: .init(name: "South Korea")!,
        platform: .iPhone)
    
    static let appUnit2 = AppUnit(
        name: "앱과사전",
        appID: 9090,
        country: .init(name: "South Korea")!,
        platform: .iPad)
  
    static let appUnit3 = AppUnit(
        name: "앱과사전",
        appID: 9090,
        country: .init(name: "South Korea")!,
        platform: .mac)
    
}
