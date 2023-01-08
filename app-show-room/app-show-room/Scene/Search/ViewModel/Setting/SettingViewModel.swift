//
//  SettingViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/25.
//

import UIKit

struct SettingViewModel {
    
    private let allCountries: [Country] = Country.list
    private var countries: [Country] = Country.list
    
    var navigationBarTitle: String = "나라 설정"
    
    var selectedCountryIndex: Int {
        let currentCountry = AppSearchingConfiguration.countryISOCode
        return Country.list.firstIndex { $0 == currentCountry } ?? 0
    }
    
    func numberOfCountry() -> Int {
        return countries.count
    }
    
    func countryName(at row: Int) -> String? {
        return countries[safe: row]?.name
    }
    
    func countryFlag(at row: Int) -> String? {
        return countries[safe: row]?.flag
    }

    func didSelectCountry(at row: Int) {
        guard let country = countries[safe: row] else {
            return
        }
        AppSearchingConfiguration.setCountry(by: country)
    }
    
    mutating func searchBarTextDidChange(to text: String) {
        guard !text.isEmpty else {
            countries = allCountries
            return
        }
        countries = allCountries.filter{
            $0.name.localizedCaseInsensitiveContains(text)
        }
    }
    
}
