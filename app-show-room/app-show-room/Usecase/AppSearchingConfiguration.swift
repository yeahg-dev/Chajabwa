//
//  AppSearchingConfiguration.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/07.
//

import Foundation

struct AppSearchingConfiguration {
    
    static let defaults = UserDefaults.standard
    
    static var softwareType: SoftwareType {
        guard let softwareTypeName = defaults.string(forKey: "softwareType"),
              let software = SoftwareType(rawValue: softwareTypeName) else {
            let defaultSoftwareType = DefaultConfiguration.softwareType
            setSoftwareType(by: defaultSoftwareType)
            print("Can not found SoftwareType. SoftwareType is set to default: \(defaultSoftwareType.rawValue)")
            return defaultSoftwareType
        }
        return software
    }
    
    static var countryISOCode: Country {
        guard let code = defaults.string(forKey: "countryISOCode"),
              let country = Country(isoCode: code) else {
            let defaultCountry = DefaultConfiguration.country
            setCountry(by: defaultCountry)
            print("Can not found Country.  SoftwareType is set to default: \(defaultCountry.isoCode)")
            return defaultCountry
        }
        return country
    }
    
    static var isActiveSavingSearchKeyword: Bool {
        return defaults.bool(forKey: "isActiveSavingSearchKeyword")
    }
    
    static func setCountry(by country: Country) {
        defaults.set(country.isoCode, forKey: "countryISOCode")
    }
    
    static func setSoftwareType(by type: SoftwareType) {
        defaults.set(type.rawValue, forKey: "softwareType")
    }
    
    static func setSavingSearchKeywordState(with bool: Bool) {
        defaults.set(bool, forKey: "isActiveSavingSearchKeyword")
    }
    
}

extension AppSearchingConfiguration {
    
    private enum DefaultConfiguration {
        
        static let softwareType: SoftwareType = SoftwareType.iPhone
        static let country: Country = Country(
            englishName: "Korea",
            koreanName: "대한민국",
            isoCode: "KR")
        static let isActiveSavingSearchKeyword: Bool = false
        
    }
    
}
