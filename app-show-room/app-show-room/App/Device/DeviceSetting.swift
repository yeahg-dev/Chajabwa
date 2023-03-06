//
//  DeviceSetting.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/02/14.
//

import Foundation

struct DeviceSetting {
    
    static var currentLanguage: SupportingLanguage {
        let mostPreferredLanguage = Locale.preferredLanguages.first
        guard let language = mostPreferredLanguage else {
            return .korean
        }
        let code = String(language.prefix(2))
        return SupportingLanguage(rawValue: code) ?? .english
    }

}
