//
//  AppDetailPreviewViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/19.
//

import Foundation

protocol AppDetailPreviewViewModel {
    
    var appID: Int? { get }
    var iconImageURL: String? { get }
    var name: String? { get }
    var provider: String? { get }
    var rating: Double? { get }
    var screenshotURLs: [String]? { get }
    
}
