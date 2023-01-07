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
    
    func allRecentSearchKeywords() async throws -> [RecentSearchKeyword] {
        let isActive = isActiveSavingSearchingKeyword()
        if isActive {
            return try await searchKeywordRepository.readAll(sorted: false)
        } else {
            return []
        }
    }
    
    func deleteRecentSearchKeyword(
        of identifier: String)
    async throws -> RecentSearchKeyword
    {
        return try await searchKeywordRepository.delete(identifier: identifier)
    }
    
    func deleteAllRecentSearchKeywords() async throws -> [RecentSearchKeyword] {
        return try await searchKeywordRepository.deleteAll()
    }
    
}
