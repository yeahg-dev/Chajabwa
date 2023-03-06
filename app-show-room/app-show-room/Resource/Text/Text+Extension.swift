//
//  Text+Extension.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/02/07.
//

import Foundation

extension Texts {
    
    static func numberOfRating(_ count: Int) -> String {
        let formattedNumber = count.formattedNumber
        return "\(formattedNumber)\(Texts.rating_unit)"
    }
    
    static func numberOfLanguage(_ count: Int) -> String {
        let formattedNumber = count.formattedNumber
        return "\(formattedNumber)\(Texts.language_unit)"
    }
    
}
