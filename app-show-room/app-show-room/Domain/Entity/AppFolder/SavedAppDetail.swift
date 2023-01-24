//
//  SavedAppDetail.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/18.
//

import Foundation

struct SavedAppDetail {
    
    private let supportedDevicesNames: [String]?
    
    let appDetali: AppDetail
    
    let name: String?
    let id: Int?
    let description: String?
    let country: Country
    let provider: String?
    let averageUserRating: Double?
    let userRatingCount: Int?
    let iconImageURL: String?
    let screenshotURLs: [String]?
    
    var supportedDevices: [Device] {
        var devices = Set<Device>()
        supportedDevicesNames?.forEach { name in
            if let device = Device.create(with: name) {
                devices.update(with: device)
            }
        }
        return Array(devices).sorted(by: { $0.rawValue > $1.rawValue } )
    }
    
    init(appDetail: AppDetail, appUnit: AppUnit) {
        self.appDetali = appDetail
        self.name = appDetail.appName
        self.id = appDetail.id
        self.description = appDetail.description
        self.supportedDevicesNames = appDetail.supportedDevices
        self.country = appUnit.country
        self.provider = appDetail.provider
        self.averageUserRating = appDetail.averageUserRating
        self.userRatingCount = appDetail.userRatingCount
        self.iconImageURL = appDetail.iconImageURL
        self.screenshotURLs = appDetail.screenShotURLs
    }
    
}
