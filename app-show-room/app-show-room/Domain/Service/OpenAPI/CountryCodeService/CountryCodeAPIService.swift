//
//  CountryCodeAPIService.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/02/13.
//

import Foundation

struct CountryCodeAPIService: APIService {
    
    var session: URLSession = URLSession(configuration: .default)
    
    func requestAllCountryCode() async throws -> [CountryCode] {
        let request = CountryCodeListRequest(pageNo: 1, numOfRows: 240)
        let countryCodeList: CountryCodeList = try await execute(request: request)
        return countryCodeList.data
    }
}
