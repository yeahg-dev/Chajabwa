//
//  Bundle+Extension.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/02/13.
//

import Foundation

extension Bundle {
    
    var countryCodeAPIKey: String {
        guard let filePath = self.path(forResource: "Secret", ofType: "plist") else {
            return ""
        }
        
        guard let resource = NSDictionary(contentsOfFile: filePath) else {
            return ""
        }
        
        guard let key = resource["countryCodeServiceAPIKey"] as? String else {
            fatalError("Secret.plist에 countryCodeServiceAPIKey를 지정해주세요")
        }
        return key
    }
}
