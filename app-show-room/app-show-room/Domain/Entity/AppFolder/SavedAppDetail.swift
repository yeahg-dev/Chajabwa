//
//  SavedAppDetail.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/18.
//

import Foundation

struct SavedAppDetail {
    
    let name: String
    let id: Int
    let description: String?
    let supportedDevices: [Device]
    let country: Country
    let provider: String
    let averageUserRating: Double
    let userRatingCount: Int
    let iconImageURL: String
    let screenshotURLs: [String]
    
}
