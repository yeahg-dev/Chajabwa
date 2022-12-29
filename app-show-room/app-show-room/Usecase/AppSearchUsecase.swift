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
    
    func searchAppDetail(of input: String) async throws -> [AppDetail] {
        let country = AppSearchingConfiguration.countryISOCode.isoCode
        let softwareType = AppSearchingConfiguration.softwareType.rawValue
        
        if let id = Int(input) {
            let appDetail = try await self.appDetailRepository.fetchAppDetail(
                of: id,
                country: country,
                software: softwareType)
            return [appDetail]
        } else {
            let appDetails = try await self.appDetailRepository.fetchAppDetails(
                of: input,
                country: country,
                software: softwareType)
            return appDetails
        }
    }
 
}
