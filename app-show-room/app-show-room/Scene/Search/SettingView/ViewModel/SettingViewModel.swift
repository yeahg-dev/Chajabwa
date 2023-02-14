//
//  SettingViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/25.
//

import UIKit

struct SettingViewModel {
    
    private let allCountries: [Country] = Country.localizedSortedList
    private var countries: [Country] = Country.localizedSortedList
    private var selecteCountry: Country = AppSearchingConfiguration.country
    
    var navigationBarTitle: String = Text.country_setting
    
    var selectedCountryIndex: Int? {
        return countries.firstIndex { $0 == selecteCountry }
    }
    
    func numberOfCountry() -> Int {
        return countries.count
    }
    
    func countryName(at row: Int) -> String? {
        return countries[safe: row]?.localizedName
    }
    
    func countryFlag(at row: Int) -> String? {
        return countries[safe: row]?.flag
    }
    
    func isSelectedCountry(at indexPath: IndexPath) -> Bool {
        return indexPath.row == selectedCountryIndex
    }

    mutating func didSelectCountry(at indexPath: IndexPath) {
        guard let country = countries[safe: indexPath.row] else {
            return
        }
        selecteCountry = country
    }
    
    func saveSetting() {
        AppSearchingConfiguration.setCountry(by: selecteCountry)
    }
    
    mutating func searchBarTextDidChange(to text: String) {
        guard !text.isEmpty else {
            countries = allCountries
            return
        }
        countries = allCountries.filter{
            $0.localizedName.localizedCaseInsensitiveContains(text)
        }
    }
    
}
