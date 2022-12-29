//
//  AppSummary.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/21.
//

import Foundation

struct AppSummary {
    
    let supportedDevices: [String]?
    let features, advisories: [String]?
    let isGameCenterEnabled: Bool?
    let screenshotUrls: [String]?
    let ipadScreenshotUrls, appletvScreenshotUrls: [String]?
    let artworkUrl60, artworkUrl512, artworkUrl100: String?
    let artistViewURL: String?
    let kind, currency, description: String?
    let releaseDate: String?
    let genreIDS: [String]?
    let bundleID, sellerName, trackName: String?
    let trackID: Int?
    let isVppDeviceBasedLicensingEnabled: Bool?
    let primaryGenreName: String?
    let primaryGenreID: Int?
    let currentVersionReleaseDate: String?
    let releaseNotes, minimumOSVersion, trackCensoredName: String?
    let languageCodesISO2A: [String]?
    let fileSizeBytes: String?
    let sellerURL: String?
    let formattedPrice, contentAdvisoryRating: String?
    let averageUserRatingForCurrentVersion: Double?
    let userRatingCountForCurrentVersion: Int?
    let averageUserRating: Double?
    let trackViewURL: String?
    let trackContentRating, version, wrapperType: String?
    let price: Int?
    let genres: [String]?
    let artistID: Int?
    let artistName: String?
    let userRatingCount: Int?
    
}

extension AppSummary: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case supportedDevices, features, advisories, isGameCenterEnabled, screenshotUrls, ipadScreenshotUrls, appletvScreenshotUrls, artworkUrl60, artworkUrl512, artworkUrl100
        case artistViewURL = "artistViewUrl"
        case kind, currency
        case description
        case releaseDate
        case genreIDS = "genreIds"
        case bundleID = "bundleId"
        case sellerName, trackName
        case trackID = "trackId"
        case isVppDeviceBasedLicensingEnabled, primaryGenreName
        case primaryGenreID = "primaryGenreId"
        case currentVersionReleaseDate, releaseNotes
        case minimumOSVersion = "minimumOsVersion"
        case trackCensoredName, languageCodesISO2A, fileSizeBytes
        case sellerURL = "sellerUrl"
        case formattedPrice, contentAdvisoryRating, averageUserRatingForCurrentVersion, userRatingCountForCurrentVersion, averageUserRating
        case trackViewURL = "trackViewUrl"
        case trackContentRating, version, wrapperType, price, genres
        case artistID = "artistId"
        case artistName, userRatingCount
    }
    
    func toAppDetail() -> AppDetail? {
        
        return AppDetail(
            id: self.trackID,
            appName: self.trackName,
            iconImageURL: self.artworkUrl512,
            provider: self.sellerName,
            price: self.formattedPrice,
            averageUserRating: self.averageUserRating,
            userRatingCount: self.userRatingCount,
            primaryGenreName: self.primaryGenreName,
            languageCodesISO2A: self.languageCodesISO2A,
            screenShotURLs: self.screenshotUrls,
            description: self.description,
            fileSize: self.fileSizeBytes,
            contentAdvisoryRating: self.contentAdvisoryRating,
            minimumOSVersion: self.minimumOSVersion,
            providerURL: self.sellerURL,
            version: self.version,
            currentVersionReleaseDate: self.currentVersionReleaseDate,
            releaseDescription: self.releaseNotes)
    }
}
