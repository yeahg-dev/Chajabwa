//
//  SavedAppDetailTableViewCellModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/19.
//

import UIKit

struct SavedAppDetailTableViewCellModel {
    
    let supportedDeviceText = "지원 기기 "
    let appStoreText = "앱 스토어 국가"
    let supportedDeviceIconImages: [UIImage?]
    let countryName: String
    let countryFlag: String
    
    let appDetailprevieViewModel: AppDetailPreviewViewModel
    
    init(savedAppDetail: SavedAppDetail) {
        self.supportedDeviceIconImages = savedAppDetail.supportedDevices.map{ $0.iconImage }
        self.countryName = savedAppDetail.country.name
        self.countryFlag = savedAppDetail.country.flag
        self.appDetailprevieViewModel = AppDetailPreviewViewModel(appDetail: savedAppDetail.appDetali)
    }
    
}
