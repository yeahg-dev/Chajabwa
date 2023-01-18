//
//  SavedAppDetailTableViewCellModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/19.
//

import UIKit

struct SavedAppDetailTableViewCellModel {
    
    let supportedDevices: [UIImage?]
    let countryName: String
    let countryFlag: String
    let name: String?
    let iconImageURL: String?
    let provider: String?
    let averageUserRating: Double?
    let userRatingCount: Int?
    let screenshotURLs: [String]?
    
    init(savedAppDetail: SavedAppDetail) {
        self.supportedDevices = savedAppDetail.supportedDevices.map{ $0.iconImage }
        self.countryName = savedAppDetail.country.name
        self.countryFlag = savedAppDetail.country.flag
        self.name = savedAppDetail.name
        self.iconImageURL = savedAppDetail.iconImageURL
        self.provider = savedAppDetail.provider
        self.averageUserRating = savedAppDetail.averageUserRating
        self.userRatingCount = savedAppDetail.userRatingCount
        self.screenshotURLs = savedAppDetail.screenshotURLs
    }
    
}
