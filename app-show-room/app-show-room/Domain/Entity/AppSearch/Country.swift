//
//  Country.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/07.
//

import UIKit

struct Country: Decodable, Equatable {
    
    // TODO: - 지역별로 이름순 sorted 핸들링
    static var list: [Country] = []
    
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
            self.englishName = country.isoCode
            self.koreanName = country.koreanName
            self.isoCode = country.isoCode
        } else {
            return nil
        }
    }
    
}
