//
//  AppOrganizer.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/03/21.
//

import Foundation

final class AppOrganizer {
    
    private let countryCodeAPIService = CountryCodeAPIService()

    func prepare(didEnd completion: @escaping (() -> Void)) {
        countryCodeAPIService.fetchCountryCodes(completion: completion)
    }
    
}
