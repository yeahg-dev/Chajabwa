//
//  RecentSearchKeywordManagementUsecase.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/01.
//

import Foundation

struct RecentSearchKeywordManagementUsecase {
    
    private let searchKeywordRepository: SearchKeywordRepository
    
    init(searchKeywordRepository: SearchKeywordRepository) {
        self.searchKeywordRepository = searchKeywordRepository
    }
    
    func isActiveSavingSearchingKeyword() -> Bool {
        return AppSearchingConfiguration.isActiveSavingSearchKeyword
    }
    
    func activateSavingSearchKeyword() {
        AppSearchingConfiguration.setSavingSearchKeywordState(with: true)
    }
    
    func deactivateSavingSearchKeyword() {
        AppSearchingConfiguration.setSavingSearchKeywordState(with: false)
    }
    
    func allRecentSearchKeywords(
        completion: @escaping (Result<[RecentSearchKeyword], Error>) -> Void)
    {
        let isActive = isActiveSavingSearchingKeyword()
        if isActive {
            searchKeywordRepository.readAll(completion: completion)
        } else {
            completion(.success([]))
        }
    }
    
    func deleteRecentSearchKeyword(
        of identifier: String,
        completion: @escaping (Result<RecentSearchKeyword, Error>) -> Void) {
        searchKeywordRepository.delete(identifier: identifier, completion: completion)
    }
    
    func deleteAllRecentSearchKeywords(completion: @escaping (Result<[RecentSearchKeyword], Error>) -> Void) {
        searchKeywordRepository.deleteAll(completion: completion)
    }
    
}
