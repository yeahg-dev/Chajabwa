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
    
    @Persisted(primaryKey: true) var identifier: String
    @Persisted var keyword: String
    @Persisted var date: Date
    @Persisted var country: String
    @Persisted var softwareType: String
    
    convenience init(model: RecentSearchKeyword) {
        self.init()
        keyword = model.keyword
        date = model.date
        country = model.configuration.country.englishName
        softwareType = model.configuration.softwareType.rawValue
        identifier = model.identifier
    }
    
    func toDomain() -> DomainEntity? {
        guard let country = Country(englishName: country),
        let software = SoftwareType(rawValue: softwareType) else {
            return nil
        }
        return RecentSearchKeyword(
            keyword: keyword,
            date: date,
            configuration: SearchConfiguration(
                country: country,
                softwareType: software),
            identifier: identifier
        )
    }
    
}
