//
//  SearchAppTableViewCellModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/09.
//

import Foundation

struct SearchAppTableViewCellModel: Hashable {
    
    let appID: Int?
    let iconImageURL: String?
    let name: String?
    let provider: String?
    let averageUserRating: Double?
    let userRatingCount: String?
    let screenshotImageURLs: [String]?
    
    init(app: AppDetail) {
        self.appID = app.id
        self.iconImageURL = app.iconImageURL
        self.name = app.appName
        self.provider = app.provider
        self.averageUserRating = app.averageUserRating
        self.userRatingCount = app.userRatingCount?.formattedNumber
        self.screenshotImageURLs = app.screenShotURLs
    }
    
}
