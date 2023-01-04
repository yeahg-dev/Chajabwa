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
        
        createRecentSearchKeyword(with: input)
        
        if let id = Int(input) {
            let appDetail = try await self.appDetailRepository.fetchAppDetail(
                of: id,
                country: configuration.country.isoCode,
                software: configuration.softwareType.rawValue)
            return [appDetail]
        } else {
            let appDetails = try await self.appDetailRepository.fetchAppDetails(
                of: input,
                country: configuration.country.isoCode,
                software: configuration.softwareType.rawValue)
            return appDetails
        }
    }
    
    func searchAppDetail(of input: String) async throws -> [AppDetail] {
        let currentCountry = AppSearchingConfiguration.countryISOCode.isoCode
        let currentSoftwareType = AppSearchingConfiguration.softwareType.rawValue
        
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
    
    private func createRecentSearchKeyword(with input: String) {
        guard !input.isEmpty else {
            return
        }
        let keyword =  RecentSearchKeyword(
            keyword: input,
            date: Date(),
            configuration: SearchConfiguration(
                country: AppSearchingConfiguration.countryISOCode,
                softwareType: AppSearchingConfiguration.softwareType))
        searchKeywordRepository.create(
            keyword: keyword) { result in
                switch result {
                case .success(_):
                    return
                case .failure(let failure):
                    print("Failed to create RecentSearchKeyword. error :\(failure)")
                }
            }
    }
    
}
