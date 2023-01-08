//
//  AppSearchUsecase.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import Foundation

struct AppSearchUsecase {
    
    private let appDetailRepository: AppDetailRepository
    private let searchKeywordRepository: SearchKeywordRepository
    
    init(
        appDetailRepository: AppDetailRepository = ItunesAppDetailRepository(),
        searchKeywordRepository: SearchKeywordRepository
    ) {
        self.appDetailRepository = appDetailRepository
        self.searchKeywordRepository = searchKeywordRepository
    }
    
    func searchAppDetail(
        of searchKeyword: RecentSearchKeyword)
    async throws -> [AppDetail]
    {
        let input = searchKeyword.keyword
        let configuration = searchKeyword.configuration
        
        createRecentSearchKeyword(with: searchKeyword)
        
        if let id = Int(input) {
            let appDetail = try await self.appDetailRepository.fetchAppDetail(
                of: id,
                country: configuration.country,
                software: configuration.softwareType)
            return [appDetail]
        } else {
            let appDetails = try await self.appDetailRepository.fetchAppDetails(
                of: input,
                country: configuration.country,
                software: configuration.softwareType)
            return appDetails
        }
    }
    
    func searchAppDetail(of input: String) async throws -> [AppDetail] {
        let currentCountry = AppSearchingConfiguration.countryISOCode
        let currentSoftwareType = AppSearchingConfiguration.softwareType
        
        createRecentSearchKeyword(with: input)
        
        if let id = Int(input) {
            let appDetail = try await self.appDetailRepository.fetchAppDetail(
                of: id,
                country: currentCountry,
                software: currentSoftwareType)
            return [appDetail]
        } else {
            let appDetails = try await self.appDetailRepository.fetchAppDetails(
                of: input,
                country: currentCountry,
                software: currentSoftwareType)
            return appDetails
        }
        
    }
    
    private func createRecentSearchKeyword(with recentKeyword: RecentSearchKeyword) {
        guard AppSearchingConfiguration.isActiveSavingSearchKeyword else {
            return
        }
        
        let keyword =  RecentSearchKeyword(
            keyword: recentKeyword.keyword,
            date: Date(),
            configuration: SearchConfiguration(
                country: recentKeyword.configuration.country,
                softwareType: recentKeyword.configuration.softwareType))
        Task {
            do {
                let _ = try await searchKeywordRepository.create(keyword: keyword)
            } catch {
                print("Failed to create RecentSearchKeyword. error :\(error)")
            }
        }
    }
    
    private func createRecentSearchKeyword(with input: String) {
        guard AppSearchingConfiguration.isActiveSavingSearchKeyword else {
            return
        }
        
        guard !input.isEmpty else {
            return
        }
        
        let keyword =  RecentSearchKeyword(
            keyword: input,
            date: Date(),
            configuration: SearchConfiguration(
                country: AppSearchingConfiguration.countryISOCode,
                softwareType: AppSearchingConfiguration.softwareType))
        Task {
            do {
                let _ = try await searchKeywordRepository.create(keyword: keyword)
            } catch {
                print("Failed to create RecentSearchKeyword. error :\(error)")
            }
        }
    }
    
}
