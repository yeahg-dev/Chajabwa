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
    private let realmQueue: DispatchQueue!
    
    init?() {
        if let searchKeywordRealm = SearckKeywordRealmStore() {
            realm = searchKeywordRealm.defaultRealm
            realmQueue = searchKeywordRealm.serialQueue
            print("📂\(self)'s file URL : \(realm.configuration.fileURL)")
        } else {
            return nil
        }
    }
    
    func create(
        keyword: RecentSearchKeyword)
    async throws -> RecentSearchKeyword
    {
        try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                let searchKeyword = RecentSearchKeywordRealm(model: keyword)
                do {
                    try realm.write {
                        realm.add(searchKeyword)
                    }
                    continuation.resume(returning: keyword)
                } catch {
                    print("failed in \(self): \(error)")
                    continuation.resume(throwing: RealmSearchKeywordRepositoryError.realmOperationFailure)
                }
            }
        }
    }
    
    func readAll(
        sorted ascending: Bool = false)
    async throws -> [RecentSearchKeyword]
    {
        try await withCheckedThrowingContinuation({ continuation in
            realmQueue.async {
                let result = realm.objects(RecentSearchKeywordRealm.self)
                    .sorted(byKeyPath: "date", ascending: ascending)
                let keywords = result.compactMap { $0.toDomain() } as [RecentSearchKeyword]
                continuation.resume(returning: keywords)
            }
        })
    }
    
    func delete(
        identifier: String)
    async throws -> RecentSearchKeyword
    {
        try await withCheckedThrowingContinuation({ continuation in
            realmQueue.async {
                guard let keywordRealm = realm.object(
                    ofType: RecentSearchKeywordRealm.self,
                    forPrimaryKey: identifier),
                      let keyword = keywordRealm.toDomain() else {
                    continuation.resume(throwing: RealmSearchKeywordRepositoryError.realmCanNotFoundObject)
                    return
                }
                do {
                    try realm.write {
                        realm.delete(keywordRealm)
                    }
                    continuation.resume(returning: keyword)
                } catch {
                    continuation.resume(throwing: RealmSearchKeywordRepositoryError.realmOperationFailure)
                }
            }
        })
    }
    
    func deleteAll() async throws -> [RecentSearchKeyword] {
        try await withCheckedThrowingContinuation({ continuation in
            realmQueue.async {
                let realmKeywords = realm.objects(RecentSearchKeywordRealm.self)
                do {
                    try realm.write {
                        realm.delete(realmKeywords)
                    }
                    let keywords = realmKeywords.compactMap { $0.toDomain() } as [RecentSearchKeyword]
                    continuation.resume(returning: keywords)
                } catch {
                    continuation.resume(throwing: RealmSearchKeywordRepositoryError.realmOperationFailure)
                }
            }
        })
    }
    
}

enum RealmSearchKeywordRepositoryError: Error {
    
    case realmOperationFailure
    case realmCanNotFoundObject
    
}
