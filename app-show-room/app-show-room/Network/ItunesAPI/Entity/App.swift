//
//  App.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import Foundation

struct App {
    
    let screenshotUrls: [String]?
    let ipadScreenshotUrls: [String]?
    let appletvScreenshotUrls: [String]?
    let artworkUrl60, artworkUrl512, artworkUrl100: String?
    let artistViewURL: String?
    let features: [String]?
    let isGameCenterEnabled: Bool?
    let supportedDevices: [String]?
    let advisories: [String]?
    let kind: String?
    let averageUserRating: Double?
    let releaseNotes, minimumOSVersion, trackCensoredName: String?
    let languageCodesISO2A: [String]?
    let fileSizeBytes, formattedPrice, contentAdvisoryRating: String?
    let averageUserRatingForCurrentVersion: Double?
    let userRatingCountForCurrentVersion: Int?
    let trackViewURL: String?
    let trackContentRating, resultDescription: String?
    let releaseDate: String?
    let bundleID, sellerName, currency, primaryGenreName: String?
    let primaryGenreID: Int?
    let currentVersionReleaseDate: String?
    let isVppDeviceBasedLicensingEnabled: Bool?
    let genreIDS: [String]?
    let version, wrapperType: String?
    let artistID: Int?
    let artistName: String?
    let genres: [String]?
    let price: Double
    let trackID: Int?
    let trackName: String?
    let userRatingCount: Int?

}

extension App: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case screenshotUrls, ipadScreenshotUrls, appletvScreenshotUrls, artworkUrl60, artworkUrl512, artworkUrl100, features, isGameCenterEnabled, supportedDevices, advisories, kind, averageUserRating, releaseNotes, trackCensoredName, languageCodesISO2A, fileSizeBytes, formattedPrice, contentAdvisoryRating, averageUserRatingForCurrentVersion, userRatingCountForCurrentVersion, trackContentRating, releaseDate, sellerName, currency, primaryGenreName,
             currentVersionReleaseDate, isVppDeviceBasedLicensingEnabled, version, wrapperType,
             artistName, genres, price, trackName, userRatingCount
        case artistViewURL = "artistViewUrl"
        case minimumOSVersion = "minimumOsVersion"
        case trackViewURL = "trackViewUrl"
        case resultDescription = "description"
        case bundleID = "bundleId"
        case primaryGenreID = "primaryGenreId"
        case genreIDS = "genreIds"
        case artistID = "artistId"
        case trackID = "trackId"

    }
}

extension App {
    
    func toAppDetail() -> AppDetail? {
        
        return AppDetail(
            id: self.trackID,
            appName: self.trackName,
            iconImageURL: self.artworkUrl512,
            provider: self.sellerName,
            price: self.formattedPrice,
            averageUserRating: self.averageUserRating,
            userRatingCount: self.userRatingCount,
            appContentRating: self.contentAdvisoryRating,
            primaryGenreName: self.primaryGenreName,
            languageCodesISO2A: self.languageCodesISO2A,
            screenShotURLs: self.screenshotUrls,
            description: self.resultDescription)
    }
}
