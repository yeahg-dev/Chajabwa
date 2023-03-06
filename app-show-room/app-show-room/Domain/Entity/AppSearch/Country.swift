//
//  Country.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/07.
//

import UIKit

struct Country: Decodable, Equatable {
    
    static var list: [Country] = []
    
    static var localizedSortedList: [Country] {
        switch DeviceSetting.currentLanguage {
        case .korean:
            return list.sorted { $0.koreanName < $1.koreanName }
        case .english:
            return list.sorted { $0.englishName < $1.englishName }
        }
    }
    
    let englishName: String
    let koreanName: String
    let isoCode: String
    
    var flag: String {
        self.isoCode
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    
    var localizedName: String {
        switch DeviceSetting.currentLanguage {
        case .korean:
            return self.koreanName
        case .english:
            return self.englishName
        }
    }
    
    init(englishName: String, koreanName: String, isoCode: String) {
        self.englishName = englishName
        self.koreanName = koreanName
        self.isoCode = isoCode
    }
    
    init?(englishName: String) {
        if let country = Country.list.first(where: { $0.englishName == englishName }) {
            self.englishName = englishName
            self.koreanName = country.koreanName
            self.isoCode = country.isoCode
        } else {
            return nil
        }
    }
    
    init?(isoCode: String) {
        if let country = Country.list.first(where: { $0.isoCode == isoCode }) {
            self.englishName = country.englishName
            self.koreanName = country.koreanName
            self.isoCode = country.isoCode
        } else {
            return nil
        }
    }
    
}
