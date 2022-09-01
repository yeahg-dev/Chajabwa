//
//  String+Extension.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/31.
//

import Foundation

extension String {
    
    enum DataUnit: String {
        
        case byte = "Byte"
        case kb = "KB"
        case mb = "MB"
        case gb = "GB"
        
        
        func representation(value: String) -> String {
            return value + self.rawValue
        }
        
    }
    
    var formattedByte: String {
        let invalidText = "제공하지 않음"
        var integerPart = Substring(self)
        var divisionCount = 0
        
        guard var byteValue = Double(Substring(self)) else {
            return invalidText
        }
        
        while integerPart.count > 3 {
            byteValue = byteValue / Double(1024)
            guard let dividedIntegerPart = String(byteValue).split(separator: ".").first else {
                return invalidText
            }
            divisionCount += 1
            integerPart = dividedIntegerPart
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        guard let formattedByteValue = numberFormatter.string(from: byteValue as NSNumber) else {
            return invalidText
        }
        
        if divisionCount == 0 {
            return DataUnit.byte.representation(value: formattedByteValue)
        } else if divisionCount == 1 {
            return DataUnit.kb.representation(value: formattedByteValue)
        } else if divisionCount == 2 {
            return DataUnit.mb.representation(value: formattedByteValue)
        } else if divisionCount == 3 {
            return DataUnit.gb.representation(value: formattedByteValue)
        }
        
        return invalidText
    }
    
}
