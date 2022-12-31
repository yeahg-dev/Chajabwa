//
//  SearchKeywordRepository.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/31.
//

import Foundation

protocol SearchKeywordRepository {
    
    @discardableResult
    func create(keyword: RecentSearchKeyword) throws -> RecentSearchKeyword
    
    func readAll() throws -> [RecentSearchKeyword]
    
    @discardableResult
    func delete(identifier: UUID) throws -> RecentSearchKeyword
    
    @discardableResult
    func deleteAll() throws -> [RecentSearchKeyword]
    
}
