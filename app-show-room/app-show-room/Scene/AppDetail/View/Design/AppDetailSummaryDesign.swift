//
//  AppDetailSummaryDesign.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/17.
//

import UIKit

enum AppDetailSummaryDesign {
    
    // margin
    static let topMargin = CGFloat(0)
    static let bottomMargin = CGFloat(20)
    static let trailingMargin = CGFloat(25)
    static let iconImageViewLeadingMargin = CGFloat(25)
    static let iconImageViewTrailingMargin = CGFloat(10)
    static let providerLabelTopMargin = CGFloat(7)
    static let shareButtonWidth = CGFloat(18)
    static let shareButtonHeight = CGFloat(10)
    
    // size
    static let purchaseButtonWidth = CGFloat(50)
    static let purchaseButtonHeight = CGFloat(25)
    
    // font
    static let appNameLabelFont: UIFont = .boldSystemFont(ofSize: 22)
    static let providerLabelFont: UIFont = .preferredFont(forTextStyle: .callout)
    static let purchaseButtonFont: UIFont = .preferredFont(forTextStyle: .callout)
    
    // image
    static let shareButtonImage = UIImage(
        systemName: "square.and.arrow.up")?.withTintColor(.systemBlue)
    static let defaultIconImage = UIImage(withBackground: .systemGray4)
}
