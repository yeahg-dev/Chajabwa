//
//  SettingViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/25.
//

import UIKit

struct SettingViewModel {
    
    var navigationBarTitle: String = "나라 설정"
    
    var selectedCountryIndex: Int {
        let currentCountry = AppSearchingConfiguration.countryISOCode
        return Country.list.firstIndex { $0 == currentCountry } ?? 0
    }
    
    func countryName(at row: Int) -> String? {
        return Country.list[safe: row]?.name
    }
    
    func countryFlag(at row: Int) -> String? {
        return Country.list[safe: row]?.flag
    }

    func didSelectCountry(at row: Int) {
        let country = Country.list[row]
        AppSearchingConfiguration.setCountry(by: country)
    }
    
}
