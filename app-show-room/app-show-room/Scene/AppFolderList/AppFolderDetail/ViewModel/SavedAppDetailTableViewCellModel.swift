//
//  SavedAppDetailTableViewCellModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/19.
//

import UIKit

struct SavedAppDetailTableViewCellModel {
    
    let supportedDeviceText = Text.supporting_device
    let appStoreText = Text.app_store
    let supportedDeviceIconImages: [UIImage?]
    let countryName: String
    let countryFlag: String
    
    let appDetailprevieViewModel: AppDetailPreviewViewModel
    
    init(savedAppDetail: SavedAppDetail) {
        self.supportedDeviceIconImages = savedAppDetail.supportedDevices.map{ $0.iconImage }
        self.countryName = savedAppDetail.country.localizedName
        self.countryFlag = savedAppDetail.country.flag
        self.appDetailprevieViewModel = AppDetailPreviewViewModel(appDetail: savedAppDetail.appDetali)
    }
    
}
