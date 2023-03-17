//
//  ItunesAppDetailRepository.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/14.
//

import Combine
import Foundation

protocol AppDetailRepository {
    
    func fetchAppDetail(
        of id: Int,
        country: Country,
        software: SoftwareType)
    async throws -> AppDetail
    
    func fetchAppDetails(
        of term: String,
        country: Country,
        software: SoftwareType)
    async throws -> [AppDetail]
    
    func fetchAppDetail(
        of id: Int,
        country: Country,
        software: SoftwareType)
    -> AnyPublisher<AppDetail, Error>
    
}

struct ItunesAppDetailRepository: AppDetailRepository {
    
    private var service: iTunesAPIService
    
    init(service: iTunesAPIService = iTunesAPIService()) {
        self.service = service
    }
    
    func fetchAppDetail(
        of id: Int,
        country: Country,
        software: SoftwareType)
    async throws -> AppDetail
    {
        let lookupRequest = AppLookupAPIRequest(
            appID: id,
            countryISOCode: country.isoCode,
            softwareType: software.rawValue)
        let lookupResponse = try await self.service.getResponse(request: lookupRequest)
        guard let app = lookupResponse.results.first else {
            throw AppDetailRepositoryError.nonExistAppDetail
        }
        
        guard let appDetail = app.toAppDetail() else {
            throw DTOError.invalidTransform
        }
        
        return appDetail
    }
    
    func fetchAppDetail(
        of id: Int,
        country: Country,
        software: SoftwareType)
    -> AnyPublisher<AppDetail, Error>
    {
        let lookupRequest = AppLookupAPIRequest(
            appID: id,
            countryISOCode: country.isoCode,
            softwareType: software.rawValue)
        
        return service.getResponse(request: lookupRequest)
            .tryMap { (lookupResults: AppLookupResults) in
                guard let app: App = lookupResults.results.first else {
                    throw AppDetailRepositoryError.nonExistAppDetail
                }
                return app
            }
            .tryMap { (app: App) in
                guard let appDetail = app.toAppDetail() else {
                    throw DTOError.invalidTransform
                }
                return appDetail
            }
            .eraseToAnyPublisher()
    }
    
    func fetchAppDetails(
        of term: String,
        country: Country,
        software: SoftwareType) async throws
    -> [AppDetail]
    {
        let searchRequest = AppSearchAPIRequest(
            term: term,
            countryISOCode: country.isoCode,
            softwareType: software.rawValue)
        let response = try await self.service.getResponse(request: searchRequest)
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
