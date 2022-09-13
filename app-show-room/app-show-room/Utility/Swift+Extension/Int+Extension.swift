//
//  Int+Extension.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/13.
//

import Foundation

extension Int {
    
    var formattedNumber: String {
        switch Locale.preferredLanguages.first {
        case "KR":
            return koreanFormattedNumber
        default:
            return englishFormattedNumber
        }
    }
    
    private enum KoreanNumberSymbol: String {
        case thousand = "천"
        case tenThousand = "만"
        case hundredMillion = "억"
        case trillion = "조"
        
        func representation(value: String) -> String {
            return value + self.rawValue
        }
        
    }
    
    private var koreanFormattedNumber: String {
        let symbol: KoreanNumberSymbol
        var number = self.description
        let digitCount = number.count
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if digitCount < 5 {
            return self.description
        } else if digitCount < 9 {
            symbol = .tenThousand
            let rangeToDelete = number.endIndex..<number.index(number.endIndex, offsetBy: -4)
            number.removeSubrange(rangeToDelete)
            let Intcoefficient = Int(number)!
            let coefficient = numberFormatter.string(from: NSNumber(value: Intcoefficient))!
            return symbol.representation(value: coefficient)
        } else if digitCount < 13 {
            symbol = .hundredMillion
            let rangeToDelete = number.endIndex..<number.index(number.endIndex, offsetBy: -8)
            number.removeSubrange(rangeToDelete)
            let Intcoefficient = Int(number)!
            let coefficient = numberFormatter.string(from: NSNumber(value: Intcoefficient))!
            return symbol.representation(value: coefficient)
        } else {
            symbol = .hundredMillion
            let rangeToDelete = number.endIndex..<number.index(number.endIndex, offsetBy: -12)
            number.removeSubrange(rangeToDelete)
            let Intcoefficient = Int(number)!
            let coefficient = numberFormatter.string(from: NSNumber(value: Intcoefficient))!
            return symbol.representation(value: coefficient)
        }
    }
    
    private enum EnglishNumberSymbol: String {
        
        case thousand = "K"
        case million = "M"
        case billion = "B"
        case trillion = "T"
        
        func representation(value: String) -> String {
            return value + self.rawValue
        }
        
    }
    
    private var englishFormattedNumber: String {
        let symbol: EnglishNumberSymbol
        var number = self.description
        let digitCount = number.count
        
        if digitCount < 4 {
            return self.description
        } else if digitCount < 7 {
            symbol = .thousand
            let rangeToDelete = number.endIndex..<number.index(number.endIndex, offsetBy: -3)
            number.removeSubrange(rangeToDelete)
            let coefficient = number
            return symbol.representation(value: coefficient)
        } else if digitCount < 10 {
            symbol = .million
            let rangeToDelete = number.endIndex..<number.index(number.endIndex, offsetBy: -6)
            number.removeSubrange(rangeToDelete)
            let coefficient = number
            return symbol.representation(value: coefficient)
        } else if digitCount < 13 {
            symbol = .billion
            let rangeToDelete = number.endIndex..<number.index(number.endIndex, offsetBy: -9)
            number.removeSubrange(rangeToDelete)
            let coefficient = number
            return symbol.representation(value: coefficient)
        } else {
            symbol = .trillion
            let rangeToDelete = number.endIndex..<number.index(number.endIndex, offsetBy: -12)
            number.removeSubrange(rangeToDelete)
            let coefficient = number
            return symbol.representation(value: coefficient)
        }
        
    }
}
