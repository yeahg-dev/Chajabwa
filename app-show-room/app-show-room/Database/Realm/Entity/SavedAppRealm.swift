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
    @Persisted var countryName: String
    @Persisted var softwareTypeName: String
    
    let folders = LinkingObjects(fromType: AppFolderRealm.self, property: "savedApps")
    
    convenience init(model: SavedApp) {
        self.init()
        identifier = model.identifier
        name = model.appUnit.name
        appID = model.appUnit.appID
        countryName = model.appUnit.country.name
        softwareTypeName = model.appUnit.platform.rawValue
    }
    
    func toDomain() -> SavedApp? {
        guard let country = Country(name: countryName),
        let platform = SoftwareType(rawValue: softwareTypeName) else {
            return nil
        }
        let appUnit = AppUnit(
            name: name,
            appID: appID,
            country: country,
            platform: platform)
        return SavedApp(
            identifier: identifier,
            appUnit: appUnit
        )
    }
    
}
