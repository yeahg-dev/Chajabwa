//
//  AppDetailSummaryDesign.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/17.
//

import UIKit

enum AppDetailSummaryDesign {
    
    // margin
    static let leadingMargin = CGFloat(25)
    static let topMargin = CGFloat(0)
    static let bottomMargin = CGFloat(20)
    static let trailingMargin = CGFloat(25)
    static let iconImageViewTrailingMargin = CGFloat(13)
    static let providerLabelTopMargin = CGFloat(7)
    
    // size
    static let width = UIScreen.main.bounds.width
    static let height = topMargin + iconImageViewHeight + bottomMargin
    static let iconImageViewWidth = UIScreen.main.bounds.width * 0.285
    static let iconImageViewHeight = UIScreen.main.bounds.width * 0.285
    static let purchaseButtonWidth = CGFloat(50)
    static let purchaseButtonHeight = CGFloat(25)
    static let shareButtonWidth = CGFloat(18)
    static let shareButtonHeight = CGFloat(10)
    
    // font
    static let appNameLabelFont: UIFont = .boldSystemFont(ofSize: 22)
    static let providerLabelFont: UIFont = .preferredFont(forTextStyle: .callout)
    static let purchaseButtonFont: UIFont = .preferredFont(forTextStyle: .callout)
    
    // image
    static let shareButtonImage = UIImage(
        systemName: "square.and.arrow.up")?.withTintColor(.systemBlue)
    static let defaultIconImage = UIImage(withBackground: .systemGray4)
    
}
