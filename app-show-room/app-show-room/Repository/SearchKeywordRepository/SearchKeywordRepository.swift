//
//  SearchKeywordRepository.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/31.
//

import Foundation

protocol SearchKeywordRepository {
    
    func create(
        keyword: RecentSearchKeyword) async throws -> RecentSearchKeyword
    
    func readAll(
        sorted ascending: Bool) async throws -> [RecentSearchKeyword]
    
    func delete(
        identifier: String) async throws -> RecentSearchKeyword
    
    func deleteAll() async throws -> [RecentSearchKeyword]
    
}
