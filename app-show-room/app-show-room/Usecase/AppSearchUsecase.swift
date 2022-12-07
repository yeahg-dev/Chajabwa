//
//  AppSearchUsecase.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import Foundation

struct AppSearchUsecase {
    
    private let appDetailRepository: AppDetailRepository
    
    init(appDetailRepository: AppDetailRepository = ItunesAppDetailRepository()) {
        self.appDetailRepository = appDetailRepository
    }
    
    func searchAppDetail(of id: String) async throws -> AppDetail {
        guard let id = Int(id) else {
            throw AppSearchUsecaseError.invalidInputType
        }
        let country = AppSearchingConfiguration.countryISOCode.isoCode
        let softwareType = AppSearchingConfiguration.softwareType.rawValue
        let appDetail = try await self.appDetailRepository.fetchAppDetail(
            of: id,
            country: country,
            software: softwareType)
        
        return appDetail
    }
 
}

enum AppSearchUsecaseError: Error {
    
    case invalidInputType
}

