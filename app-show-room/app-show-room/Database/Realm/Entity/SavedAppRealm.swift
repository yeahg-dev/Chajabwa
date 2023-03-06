//
//  SavedAppRealm.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/10.
//

import Foundation

import RealmSwift

class SavedAppRealm: Object {
    
    typealias DomainEntity = SavedApp
    
    @Persisted(primaryKey: true) var identifier: String
    @Persisted var name: String
    @Persisted var appID: Int
    @Persisted var searchinConturyISOCode: String
    @Persisted var searchingPlatformName: String
    @Persisted var iconImageURL: String?
    
    @Persisted var folders = LinkingObjects(fromType: AppFolderRealm.self, property: "savedApps")
    
    convenience init(model: SavedApp) {
        self.init()
        identifier = model.identifier
        name = model.appUnit.name
        appID = model.appUnit.appID
        searchinConturyISOCode = model.appUnit.searchingContury.isoCode
        searchingPlatformName = model.appUnit.searchingPlatform.rawValue
        iconImageURL = model.iconImageURL
    }
    
    func toDomain() -> SavedApp? {
        guard let country = Country(isoCode: searchinConturyISOCode),
        let platform = SoftwareType(rawValue: searchingPlatformName) else {
            return nil
        }
        let appUnit = AppUnit(
            name: name,
            appID: appID,
            searchingContury: country,
            searchingPlatform: platform)
        return SavedApp(
            identifier: identifier,
            appUnit: appUnit,
            iconImageURL: iconImageURL
        )
    }
    
}
