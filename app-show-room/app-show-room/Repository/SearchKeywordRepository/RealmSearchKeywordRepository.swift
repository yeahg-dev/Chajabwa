//
//  RealmSearchKeywordRepository.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/31.
//

import Foundation

import RealmSwift

struct RealmSearchKeywordRepository: SearchKeywordRepository {
    
    private let realm: Realm!
    
    init?() {
        if let searchKeywordRealm = SearckKeywordRealmStore()?.defaultRealm {
            realm = searchKeywordRealm
        } else {
            return nil
        }
    }
    
    func create(keyword: RecentSearchKeyword) throws -> RecentSearchKeyword {
        let searchKeyword = RecentSearchKeywordRealm(model: keyword)
        do {
            try realm.write {
                realm.add(searchKeyword)
            }
            return keyword
        } catch {
            print("failed in \(self): \(error)")
            throw RealmSearchKeywordRepositoryError.realmOperationFailure
        }
    }
    
    func readAll() -> [RecentSearchKeyword] {
        let result = realm.objects(RecentSearchKeywordRealm.self)
        return result.compactMap { $0.toDomain() }
    }
    
    func delete(identifier: UUID) throws -> RecentSearchKeyword {
        guard let keywordRealm = realm.object(
            ofType: RecentSearchKeywordRealm.self,
            forPrimaryKey: identifier),
              let keyword = keywordRealm.toDomain() else {
            throw RealmSearchKeywordRepositoryError.realmCanNotFoundObject
        }
        
        do {
            try realm.write {
                realm.delete(keywordRealm)
            }
            return keyword
        } catch {
            throw RealmSearchKeywordRepositoryError.realmOperationFailure
        }
    }
    
    func deleteAll() throws -> [RecentSearchKeyword] {
        let keywords = realm.objects(RecentSearchKeywordRealm.self)
        do {
            try realm.write {
                realm.delete(keywords)
            }
            return keywords.compactMap { $0.toDomain() }
        } catch {
            throw RealmSearchKeywordRepositoryError.realmOperationFailure
        }
    }
    
}

enum RealmSearchKeywordRepositoryError: Error {
    
    case realmOperationFailure
    case realmCanNotFoundObject
    
}
