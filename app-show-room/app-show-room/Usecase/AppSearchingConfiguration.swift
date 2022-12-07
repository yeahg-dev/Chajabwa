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
            print("Can not found SoftwareType")
            return SoftwareType(rawValue: "software")!
        }
        return software
    }
    
    static var countryISOCode: Country {
        guard let code = defaults.string(forKey: "countryISOCode"),
              let country = Country.all[code] else {
            print("Can not found Country")
            return Country(name: "Korea, Republic of South Korea", dialCode: "+82", isoCode: "KR")
        }
        return country
    }
    
    static func setCountry(by country: Country) {
        defaults.set(country.isoCode, forKey: "countryISOCode")
    }
    
    static func setSoftwareType(by type: SoftwareType) {
        defaults.set(type.rawValue, forKey: "softwareType")
    }
    
}
