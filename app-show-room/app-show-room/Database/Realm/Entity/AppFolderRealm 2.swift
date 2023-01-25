//
//  AppFolderRealm.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/10.
//

import Foundation

import RealmSwift

class AppFolderRealm: Object {
    
    typealias DomainEntity = AppFolder
    
    @Persisted(primaryKey: true) var identifier: String
    @Persisted var name: String
    @Persisted var folderDescription: String?
    @Persisted var savedApps = List<SavedAppRealm>()
    
    var iconImageURL: String? {
        return savedApps.first?.iconImageURL
    }
    
    convenience init(model: AppFolder) {
        self.init()
        identifier = model.identifier
        name = model.name
        folderDescription = model.description
    }
    
    func toDomain() -> AppFolder? {
        return AppFolder(
            identifier: identifier,
            savedApps: savedApps.compactMap{ $0.toDomain()},
            name: name,
            description: folderDescription,
            iconImageURL: iconImageURL)
    }
    
}
