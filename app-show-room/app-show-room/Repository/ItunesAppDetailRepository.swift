//
//  ItunesAppDetailRepository.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/14.
//

import Foundation

protocol AppDetailRepository {
    
    func fetchAppDetail(
        of id: Int,
        country: String,
        software: String)
    async throws -> AppDetail
    
    func fetchAppDetails(
        of term: String,
        country: String,
        software: String) async throws
    -> [AppDetail]
    
}

struct ItunesAppDetailRepository: AppDetailRepository {
    
    private var service: iTunesAPIService
    
    init(service: iTunesAPIService = iTunesAPIService()) {
        self.service = service
    }
    
    func fetchAppDetail(
        of id: Int,
        country: String,
        software: String)
    async throws -> AppDetail
    {
        let lookupRequest = AppLookupAPIRequest(
            appID: id,
            country: country,
            softwareType: software)
        let lookupResponse = try await self.service.execute(request: lookupRequest)
        guard let app = lookupResponse.results.first else {
            throw AppDetailRepositoryError.nonExistAppDetail
        }
        
        guard let appDetail = app.toAppDetail() else {
            throw DTOError.invalidTransform
        }
        
        return appDetail
    }
    
    func fetchAppDetails(
        of term: String,
        country: String,
        software: String) async throws
    -> [AppDetail]
    {
        let searchRequest = AppSearchAPIRequest(
            term: term,
            country: country,
            softwareType: software)
        let response = try await self.service.execute(request: searchRequest)
        if response.results.isEmpty {
            return []
        } else {
            return response.results.compactMap{ $0.toAppDetail() }
        }
    }
    
}

enum AppDetailRepositoryError: Error {
    
    case nonExistAppDetail
}
