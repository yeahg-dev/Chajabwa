//
//  AppDetail.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/12.
//

import Foundation

struct AppDetail {
    
    let id: Int?
    let appName: String?
    let iconImageURL: String?
    let provider: String?
    let price: String?
    let averageUserRating: Double?
    let userRatingCount: Int?
    let primaryGenreName: String?
    let languageCodesISO2A: [String]?
    let screenShotURLs: [String]?
    let description: String?
    let fileSize: String?
    let contentAdvisoryRating: String?
    let minimumOSVersion: String?
    let providerURL: String?
    let version: String?
    let currentVersionReleaseDate: Date?
    let releaseDescription: String?
    let supportedDevices: [String]?
    
}

extension AppDetail {
    
    static let placeholder = AppDetail(
        id: nil,
        appName: Texts.unable_to_download,
        iconImageURL: nil,
        provider: Texts.unable_to_download,
        price: Texts.unable_to_download,
        averageUserRating: nil,
        userRatingCount: nil,
        primaryGenreName: Texts.unable_to_download,
        languageCodesISO2A: nil,
        screenShotURLs: nil,
        description: Texts.unable_to_download,
        fileSize: Texts.unable_to_download,
        contentAdvisoryRating: Texts.unable_to_download,
        minimumOSVersion: Texts.unable_to_download,
        providerURL: Texts.unable_to_download,
        version: Texts.unable_to_download,
        currentVersionReleaseDate: nil,
        releaseDescription: Texts.unable_to_download,
        supportedDevices: nil)
}
