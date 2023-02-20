//
//  AppSearchingConfiguration.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/07.
//

import Combine
import Foundation

struct AppSearchingConfiguration {
    
    static let defaults = UserDefaults.standard
    
    static var softwareType: SoftwareType {
        guard let softwareTypeName = defaults.string(forKey: UserDefaultsKey.softwareType),
              let software = SoftwareType(rawValue: softwareTypeName) else {
            let defaultSoftwareType = DefaultConfiguration.softwareType
            setSoftwareType(by: defaultSoftwareType)
            print("Can not found SoftwareType. SoftwareType is set to default: \(defaultSoftwareType.rawValue)")
            return defaultSoftwareType
        }
        return software
    }
    
    static var country: Country {
        guard let code = defaults.string(forKey: UserDefaultsKey.isoCode),
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
        defaults.set(country.isoCode, forKey: UserDefaultsKey.isoCode)
    }
    
    static func setSoftwareType(by type: SoftwareType) {
        defaults.set(type.rawValue, forKey: UserDefaultsKey.softwareType)
    }
    
    static func setSavingSearchKeywordState(with bool: Bool) {
        defaults.set(bool, forKey: UserDefaultsKey.isActiveSavingSearchKeyword)
    }
    
    func downloadCountryCode() async throws {
        guard Country.list.isEmpty else {
            return
        }
        do {
            let countryCodes = try await CountryCodeAPIService().requestAllCountryCode()
            Country.list += countryCodes.compactMap {$0.toDomain()}
        } catch {
            print("CountryCodeAPIService 실패")
            throw AppSearchConfigurationError.conturyCodeDownloadError
        }
    }
}

extension AppSearchingConfiguration {
    
    // MARK: - DefaultConfiguration
    
    private enum DefaultConfiguration {
        
        static let softwareType: SoftwareType = SoftwareType.iPhone
        static let country: Country = Country(
            englishName: "Korea",
            koreanName: "대한민국",
            isoCode: "KR")
        static let isActiveSavingSearchKeyword: Bool = false
        
    }
    
    // MARK: - UserDefaultsKey
    
    private struct UserDefaultsKey {
        
        static let isoCode = "countryISOCode"
        static let softwareType = "softwareType"
        static let isActiveSavingSearchKeyword = "isActiveSavingSearchKeyword"
        
    }
    
}

enum AppSearchConfigurationError: Error {
    
    case conturyCodeDownloadError
    
}
