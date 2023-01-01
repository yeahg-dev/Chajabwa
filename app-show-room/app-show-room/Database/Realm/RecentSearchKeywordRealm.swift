//
//  RecentSearchKeywordRealm.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/31.
//

import Foundation

import RealmSwift

class RecentSearchKeywordRealm: Object {
    
    typealias DomainEntity = RecentSearchKeyword
    
    @Persisted(primaryKey: true) var identifier: UUID
    @Persisted var keyword: String
    @Persisted var date: Date
    @Persisted var country: String
    @Persisted var softwareType: String
    
    init(model: RecentSearchKeyword) {
        super.init()
        keyword = model.keyword
        date = model.date
        country = model.configuration.country.name
        softwareType = model.configuration.softwareType.rawValue
        self.identifier = model.identifier
    }
    
    func toDomain() -> DomainEntity? {
        guard let country = Country(name: country),
        let software = SoftwareType(rawValue: softwareType) else {
            return nil
        }
        return RecentSearchKeyword(
            keyword: keyword,
            date: date,
            configuration: SearchConfiguration(
                country: country,
                softwareType: software)
        )
    }
    
}
