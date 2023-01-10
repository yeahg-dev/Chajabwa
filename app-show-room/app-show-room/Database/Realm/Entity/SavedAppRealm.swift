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
        name = model.name
        appID = model.appID
        countryName = model.country.name
        softwareTypeName = model.platform.rawValue
    }
    
    func toDomain() -> SavedApp? {
        guard let country = Country(name: countryName),
        let software = SoftwareType(rawValue: softwareTypeName) else {
            return nil
        }
        return SavedApp(
            identifier: identifier,
            name: name,
            appID: appID,
            country: country,
            platform: software
        )
    }
    
}
