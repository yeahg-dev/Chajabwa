//
//  AppDetailPreviewViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/19.
//

import Foundation

struct AppDetailPreviewViewModel {
    
    var appID: Int?
    var iconImageURL: String?
    var name: String?
    var provider: String?
    var averageUserRating: Double?
    var userRatingCount: String?
    var screenshotURLs: [String]?
    
    init(appDetail: AppDetail) {
        self.appID = appDetail.id
        self.iconImageURL = appDetail.iconImageURL
        self.name = appDetail.appName
        self.provider = appDetail.provider
        self.averageUserRating = appDetail.averageUserRating
        self.userRatingCount = appDetail.userRatingCount?.formattedNumber
        self.screenshotURLs = appDetail.screenShotURLs
    }
    
}

