//
//  DescriptionCollectionViewCellDesign.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/17.
//

import UIKit

enum DescriptionCollectionViewCellDesign {
    
    // padding, spacing
    static let paddingLeading = AppDetailCollectionViewCellDesign.paddingLeading
    static let paddingTop = AppDetailCollectionViewCellDesign.paddingTop
    static let paddingTrailing = AppDetailCollectionViewCellDesign.paddingTrailing
    static let paddingBottom = AppDetailCollectionViewCellDesign.paddingBottom
    
    static let descriptionTextViewMarginBottom: CGFloat = 5
    
    // size
    static let foldingButtonWidth: CGFloat = 100
    static let foldingButtonHeight: CGFloat = 25
    
    // textContainer
    static let textContainerInsetTop: CGFloat = 0
    static let textContainerInsetLeft: CGFloat = -5
    static let textContainerInsetBottom: CGFloat = 0
    static let textContainerInsetRight: CGFloat = -5
    
    // font
    static let foldingButtonFont: UIFont = .preferredFont(forTextStyle: .callout)
    static let decriptionTextViewFont: UIFont = .preferredFont(forTextStyle: .callout)
    
    // numberOfLines
    static let textContainerMaximumNumberOfLines = 0
    static let textContainerMinimumNumberOfLines = 3

    // textColor
    static let foldingButtonTextColor: UIColor = .systemBlue
}
