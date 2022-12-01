//
//  ItunesAppDetailRepository.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/14.
//

import Foundation

protocol AppDetailRepository {
    
    func fetchAppDetail(of id: Int) async throws -> AppDetail
    
}

struct ItunesAppDetailRepository: AppDetailRepository {
    
    private var service: iTunesAPIService
    
    init(service: iTunesAPIService = iTunesAPIService()) {
        self.service = service
    }
    
    func fetchAppDetail(of id: Int) async throws -> AppDetail {
        let lookupRequest = AppLookupAPIRequest(appID: id)
        let lookupResponse = try await self.service.execute(request: lookupRequest)
        guard let app = lookupResponse.results.first else {
            throw AppDetailRepositoryError.nonExistAppDetail
        }
        
        guard let appDetail = app.toAppDetail() else {
            throw DTOError.invalidTransform
        }
        
        return appDetail
    }
    
}

enum AppDetailRepositoryError: Error {
    
    case nonExistAppDetail
}
