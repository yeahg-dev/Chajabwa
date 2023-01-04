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
    
    func create(
        keyword: RecentSearchKeyword,
        completion: @escaping (Result<RecentSearchKeyword, Error>) -> Void)
    {
        DispatchQueue.main.async {
            let searchKeyword = RecentSearchKeywordRealm(model: keyword)
            do {
                try realm.write {
                    realm.add(searchKeyword)
                }
                completion(.success(searchKeyword.toDomain()!))
            } catch {
                print("failed in \(self): \(error)")
                completion(.failure(RealmSearchKeywordRepositoryError.realmOperationFailure))
            }
        }
    }
    
    func readAll(
        completion: @escaping (Result<[RecentSearchKeyword], Error>) -> Void)
    {
        DispatchQueue.main.async {
            let result = realm.objects(RecentSearchKeywordRealm.self)
            let keywords = result.compactMap { $0.toDomain() } as [RecentSearchKeyword]
            completion(.success(keywords))
        }
    }
    
    func delete(
        identifier: String,
        completion: @escaping (Result<RecentSearchKeyword, Error>) -> Void)
    {
        DispatchQueue.main.async {
            guard let keywordRealm = realm.object(
                ofType: RecentSearchKeywordRealm.self,
                forPrimaryKey: identifier),
                  let keyword = keywordRealm.toDomain() else {
                completion(.failure(RealmSearchKeywordRepositoryError.realmCanNotFoundObject))
                return
            }
            
            do {
                try realm.write {
                    realm.delete(keywordRealm)
                }
                completion(.success(keyword))
            } catch {
                completion(.failure(RealmSearchKeywordRepositoryError.realmOperationFailure))
            }
        }
    }
    
    func deleteAll(
        completion: @escaping (Result<[RecentSearchKeyword], Error>) -> Void)
    {
        DispatchQueue.main.async {
            let realmKeywords = realm.objects(RecentSearchKeywordRealm.self)
            do {
                try realm.write {
                    realm.delete(realmKeywords)
                }
                let keywords = realmKeywords.compactMap { $0.toDomain() } as [RecentSearchKeyword]
                completion(.success(keywords))
            } catch {
                completion(.failure(RealmSearchKeywordRepositoryError.realmOperationFailure))
            }
        }
    }

}

enum RealmSearchKeywordRepositoryError: Error {
    
    case realmOperationFailure
    case realmCanNotFoundObject
    
}
