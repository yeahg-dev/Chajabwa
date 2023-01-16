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
        let targetAppFolder = DummyEntity.contentsAppFolder
        
        _ = try await sut.create(appFolder: targetAppFolder)
        let fetcheAppFolder = try await sut.fetch(identifier: targetAppFolder.identifier)
        
        XCTAssertEqual(targetAppFolder, fetcheAppFolder)
    }
    
    func test_AppFolder_name_update가_정상적으로되는지()
    async throws
    {
        let newName = "새로운 이름"
        let targetAppFolder = DummyEntity.contentsAppFolder
        
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
        let targetAppFolder = DummyEntity.contentsAppFolder
        
        let createdAppFolder = try await sut.create(appFolder: targetAppFolder)
        let updatedAppFolder = try await sut.updateDescription(
            with: newDescription,
            of: createdAppFolder)
        
        XCTAssertEqual(updatedAppFolder.description, newDescription)
    }
    
    func test_AppFolder에_SavedApp이_정상적으로_추가되는지()
    async throws
    {
        let targetAppFolder = DummyEntity.contentsAppFolder
        let dummyAppUnit = DummyEntity.netflixAppUnit
        
        let createdAppFolder = try await sut.create(appFolder: targetAppFolder)
        // MARK: - API 변경
        let updatedAppFolder = try await sut.append(
            dummyAppUnit,
            iconImageURL: DummyEntity.netflixIconImageURL,
            to: createdAppFolder)
        
        XCTAssertEqual(updatedAppFolder.appCount, 1)
        XCTAssertEqual(updatedAppFolder.savedApps.first!.appUnit, dummyAppUnit)
        XCTAssertEqual(updatedAppFolder.iconImageURL, DummyEntity.netflixIconImageURL)
    }
    
    func test_AppFolder에_SavedApp3개가_정상적으로_추가되는지()
    async throws
    {
        let targetAppFolder = DummyEntity.contentsAppFolder
        let dummyAppUnits = [DummyEntity.netflixAppUnit,
                              DummyEntity.kurlyAppUnit,
                              DummyEntity.AirbnbAppUnit]
        
        let createdAppFolder = try await sut.create(appFolder: targetAppFolder)
        try await sut.append(
            dummyAppUnits[0],
            iconImageURL: DummyEntity.netflixIconImageURL,
            to: createdAppFolder)
        try await sut.append(
            dummyAppUnits[1],
            iconImageURL: DummyEntity.kurlyIconImageURL,
            to: createdAppFolder)
        try await sut.append(
            dummyAppUnits[2],
            iconImageURL: DummyEntity.airbnbIconImageURL,
            to: createdAppFolder)
        let savedApps = try await sut.fetchSavedApps(from: createdAppFolder)
        let appFolder = try await sut.fetch(identifier: targetAppFolder.identifier)
        
        XCTAssertEqual(savedApps.map{$0.appUnit}, dummyAppUnits)
        XCTAssertEqual(appFolder.iconImageURL, DummyEntity.netflixIconImageURL)
    }
    
    func test_AppFolder에서_savedApp을_정상적으로_삭제하는지()
    async throws
    {
        let targetAppFolder = DummyEntity.contentsAppFolder
        let dummySavedAppUnit = DummyEntity.netflixAppUnit
        
        let createdAppFolder = try await sut.create(appFolder: targetAppFolder)
        let updatedAppFolder = try await sut.append(
            dummySavedAppUnit,
            iconImageURL: DummyEntity.netflixIconImageURL,
            to: createdAppFolder)
        if let savedApp = await sut.fetchSavedApp(dummySavedAppUnit) {
            let appFolder = try await sut.delete(
                [savedApp],
                in: updatedAppFolder)
            XCTAssertEqual(appFolder.appCount, 0)
            XCTAssertEqual(appFolder.iconImageURL, nil)
        } else {
            print("Failed to fetch SavedApp")
        }
      
    }
    
    func test_AppFolder에_savedApp을_추가한뒤_SavedApp이_fetch되는지()
    async throws
    {
        let dummyAppFolder = DummyEntity.contentsAppFolder
        let dummyAppUnit = DummyEntity.netflixAppUnit
        
        let createdAppFolder = try await sut.create(
            appFolder: dummyAppFolder)
        try await sut.append(
            dummyAppUnit,
            iconImageURL: DummyEntity.netflixIconImageURL,
            to: createdAppFolder)
        if let savedApp = await sut.fetchSavedApp(dummyAppUnit) {
            XCTAssertEqual(savedApp.appUnit, dummyAppUnit)
        } else {
            XCTFail("Failed To fetch SavedApp")
        }
    }
    
    func test_savedApp에_연결된appFolder가_없을때_fetchAppFolder를_호출하면_빈배열을_반환하는지()
    async throws
    {
        let dummySavedAppUnit = DummyEntity.netflixAppUnit
        
        let savedApp = await sut.createSavedApp(
            dummySavedAppUnit,
            iconImageURL: DummyEntity.netflixIconImageURL)
        let result = try await sut.fetchAppFolders(of: savedApp)
        
        XCTAssertEqual(result.isEmpty, true)
    }
    
    func test_savedApp에_연결된appFolder가_있을때_fetchAppFolder를_호출하면_첫번째AppFolder를_반환하는지()
    async throws
    {
        let dummyAppFolder = DummyEntity.contentsAppFolder
        let dummyAppFolder2 = DummyEntity.uiCoolAppFolder
        let dummySavedAppUnit = DummyEntity.netflixAppUnit
        
        let appFolder = try await sut.create(appFolder: dummyAppFolder)
        let appFolder2 = try await sut.create(appFolder: dummyAppFolder2)
        let savedApp = await sut.createSavedApp(
            dummySavedAppUnit,
            iconImageURL: DummyEntity.netflixIconImageURL)
        try await sut.append(
            dummySavedAppUnit,
            iconImageURL: DummyEntity.netflixIconImageURL,
            to: dummyAppFolder)
        try await sut.append(
            dummySavedAppUnit,
            iconImageURL: DummyEntity.netflixIconImageURL,
            to: dummyAppFolder2)
        
        let result = try await sut.fetchAppFolders(of: savedApp).first
        
        XCTAssertEqual(result, appFolder)
    }

    func test_2개의AppFolder로_updateAppFolder_호출하면_SavedApp이_변경된Folder를_반환하는지()
    async throws {
        let dummyAppFolder = DummyEntity.contentsAppFolder
        let dummyAppFolder2 = DummyEntity.uiCoolAppFolder
        let dummyAppFolder3 = DummyEntity.travelAppFolder
        let dummySavedAppUnit = DummyEntity.netflixAppUnit
        
        let appFolder = try await sut.create(appFolder: dummyAppFolder)
        let appFolder2 = try await sut.create(appFolder: dummyAppFolder2)
        let appFolder3 = try await sut.create(appFolder: dummyAppFolder3)
        try await sut.append(
            dummySavedAppUnit,
            iconImageURL: DummyEntity.netflixIconImageURL,
            to: appFolder)
        guard let savedApp = await sut.fetchSavedApp(dummySavedAppUnit) else {
            XCTFail("Faild to fetch SavedApp")
            return
        }
        
        try await sut.updateAppFolder(
            of: savedApp,
            to: [appFolder2, appFolder3])
        let folders = await sut.fetchAppFolders(of: savedApp)
        
        XCTAssertEqual(folders, [appFolder2, appFolder3])
    }
    
    func test_appFolder_3개를_저장하고_fetchAllAppFolder호출하면_3개_appFolder가_반환되는지()
    async throws
    {
        let appFolders = [DummyEntity.contentsAppFolder, DummyEntity.uiCoolAppFolder, DummyEntity.travelAppFolder]
        for appFolder in appFolders {
            try await sut.create(appFolder: appFolder)
        }
        
        let result = await sut.fetchAllAppFolders()
        
        XCTAssertEqual(result, appFolders)
    }
    
}

private enum DummyEntity {
    
    static let netflixIconImageURL = "https://is4-ssl.mzstatic.com/image/thumb/Purple122/v4/9d/b9/d4/9db9d422-cdb3-4069-e822-c28086892f00/AppIcon-1x_U007emarketing-0-0-0-10-0-0-0-85-220-0.png/60x60bb.jpg"
    
    static let kurlyIconImageURL = "https://is2-ssl.mzstatic.com/image/thumb/Purple113/v4/19/72/91/1972917f-e9c1-ddde-58c4-7a1142c20268/AppIcon-1x_U007emarketing-0-7-0-85-220.png/60x60bb.jpg"
    
    static let airbnbIconImageURL =
    "https://is5-ssl.mzstatic.com/image/thumb/Purple122/v4/69/66/3b/69663b22-6c31-e599-d6ff-9133166692b9/AppIcon-1x_U007emarketing-0-7-0-0-0-85-220-0.png/60x60bb.jpg"
    
    static let contentsAppFolder = AppFolder(
        savedApps: [],
        name: "컨텐츠 앱",
        description: "테스트 참고용",
        iconImageURL: nil)
    
    static let uiCoolAppFolder = AppFolder(
        savedApps: [],
        name: "UI Cool 앱",
        description: "참고용",
        iconImageURL: nil)
    
    static let travelAppFolder = AppFolder(
        savedApps: [],
        name: "여행",
        description: "참고용",
        iconImageURL: nil)
    
    static let netflixAppUnit = AppUnit(
        name: "앱과사전",
        appID: 9090,
        country: .init(name: "South Korea")!,
        platform: .iPhone)
    
    static let kurlyAppUnit = AppUnit(
        name: "앱과사전",
        appID: 9090,
        country: .init(name: "South Korea")!,
        platform: .iPad)
  
    static let AirbnbAppUnit = AppUnit(
        name: "앱과사전",
        appID: 9090,
        country: .init(name: "South Korea")!,
        platform: .mac)
    
}
