//
//  SummaryCollectionViewCellDesign.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/17.
//

import UIKit

enum SummaryCollectionViewCellDesign {
    
    // padding, margin
    static let paddingLeading = AppDetailCollectionViewCellDesign.paddingLeading
    static let paddingTop: CGFloat = 0
    static let paddingBottom = AppDetailCollectionViewCellDesign.paddingBottom
    static let paddingTrailing = AppDetailCollectionViewCellDesign.paddingTrailing
    
    static let iconImageViewTrailingMargin = CGFloat(13)
    static let providerLabelTopMargin = CGFloat(7)
    
    // size
    static let width = UIScreen.main.bounds.width
    static let height = paddingTop + iconImageViewHeight + paddingBottom
    static let iconImageViewWidth = UIScreen.main.bounds.width * 0.285
    static let iconImageViewHeight = UIScreen.main.bounds.width * 0.285
    static let purchaseButtonWidth: CGFloat = 70
    static let purchaseButtonHeight: CGFloat = 25
    static let shareButtonWidth: CGFloat = 18
    static let shareButtonHeight: CGFloat = 10
    
    // layer
    static let iconImageViewCornerRadius: CGFloat = 20
    static let icomImageViewBorderColor: CGColor = UIColor.systemGray4.cgColor
    static let iconImageViewBorderWidth: CGFloat = 0.5
    static let purchaseButtonCornerRadius: CGFloat = 13
    
    // numberOfLines
    static let appNameLabelNumberOfLines: Int = 2
    static let providerLabelNumberOfLines: Int = 1

    // font
    static let appNameLabelFont: UIFont = .boldSystemFont(ofSize: 22)
    static let providerLabelFont: UIFont = .preferredFont(forTextStyle: .callout)
    static let purchaseButtonFont: UIFont = .preferredFont(forTextStyle: .callout)
    
    // image
    static let shareButtonImage = UIImage(
        systemName: "square.and.arrow.up")?.withTintColor(.systemBlue)
    static let defaultIconImage = UIImage(withBackground: .systemGray4)
    
    // textColor
    static let appNameLabelTextColor: UIColor = .systemGray
    static let purchaseButtonTextColor: UIColor = .white
    
    // backgroundColor
    static let purchaseButtonBackgroundColor: UIColor = .systemBlue
    
}
