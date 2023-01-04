//
//  SearchKeywordRepository.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/31.
//

import Foundation

protocol SearchKeywordRepository {
    
    func create(
        keyword: RecentSearchKeyword,
        completion: @escaping (Result<RecentSearchKeyword, Error>) -> Void)
    
    func readAll(
        completion: @escaping (Result<[RecentSearchKeyword], Error>) -> Void)
    
    func delete(
        identifier: String,
        completion: @escaping (Result<RecentSearchKeyword, Error>) -> Void)
    
    func deleteAll(
        completion: @escaping (Result<[RecentSearchKeyword], Error>) -> Void)
    
}
