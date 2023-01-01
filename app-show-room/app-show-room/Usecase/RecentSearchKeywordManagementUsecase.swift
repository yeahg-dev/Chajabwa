//
//  RecentSearchKeywordManagementUsecase.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/01.
//

import Foundation

struct RecentSearchKeywordManagementUsecase {
    
    private let searchKeywordRepository: SearchKeywordRepository
    
    func isActiveSavingSearchingKeyword() -> Bool {
        return AppSearchingConfiguration.isActiveSavingSearchKeyword
    }
    
    func activateSavingSearchKeyword() {
        AppSearchingConfiguration.setSavingSearchKeywordState(with: true)
    }
    
    func deactivateSavingKeyword() {
        AppSearchingConfiguration.setSavingSearchKeywordState(with: false)
    }
    
    func recentSearchKeywords() throws -> [RecentSearchKeyword] {
        try searchKeywordRepository.readAll()
    }
    
    func deleteRecentSearchKeyword(of identifier: UUID) throws {
        try searchKeywordRepository.delete(identifier: identifier)
    }
    
    func deleteAllRecentSearchKeywords() throws {
        try searchKeywordRepository.deleteAll()
    }
    
}
