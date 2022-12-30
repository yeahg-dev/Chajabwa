//
//  Country.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/07.
//

import UIKit

struct Country: Decodable, Equatable {
    
    static let hashTable: [String: Country] = {
        let data = NSDataAsset(name: "CountryCodes")!
        let countries = try! JSONDecoder().decode([Country].self, from: data.data)
        var all = [String: Country]()
        for country in countries {
            all[country.isoCode] = country
        }
        return all
    }()
    
    static let list: [Country] = {
        let data = NSDataAsset(name: "CountryCodes")!
        let countries = try! JSONDecoder().decode([Country].self, from: data.data)
        return countries.sorted(by: {$0.name < $1.name})
    }()
    
    let name: String
    let dialCode: String
    let isoCode: String
    
    var flag: String {
        self.isoCode
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    
    private enum CodingKeys: String, CodingKey {
        
        case name
        case dialCode = "dial_code"
        case isoCode = "code"
        
    }
    
}
