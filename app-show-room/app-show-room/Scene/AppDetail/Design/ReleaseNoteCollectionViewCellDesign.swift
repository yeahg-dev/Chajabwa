//
//  ReleaseNoteCollectionViewCellDesign.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/02.
//

import UIKit

enum ReleaseNoteCollectionViewCellDesign {
    
    // padding
    static let paddingLeading = AppDetailCollectionViewCellDesign.paddingLeading
    static let paddingTop = AppDetailCollectionViewCellDesign.paddingTop
    static let paddingTrailing = AppDetailCollectionViewCellDesign.paddingTrailing
    static let paddingBottom = AppDetailCollectionViewCellDesign.paddingBottom
    
    // margin
    static let desciptionTextViewMarginBottom: CGFloat = 5
    static let descriptionTextViewMarginTop: CGFloat = 10
    
    // textContainer
    static let textContainerInsetTop: CGFloat = 0
    static let textContainerInsetLeft: CGFloat = -5
    static let textContainerInsetRight: CGFloat = -5
    static let textContainerInsetBottom: CGFloat = 0
    
    static let textContainerMaximumNumberOfLines: Int = 3
    static let textContainerMinimumNumberOfLines: Int = 0
    
    // size
    static let foldingButtonWidth: CGFloat = 100
    static let foldingButtonHeight: CGFloat = 25
    
    // font
    static let versionFont: UIFont = .preferredFont(forTextStyle: .callout)
    static let currentVersionReleaseDateFont: UIFont = .preferredFont(forTextStyle: .callout)
    static let foldingButtonFont: UIFont = .preferredFont(forTextStyle: .callout)
    static let decriptionTextViewFont: UIFont = .preferredFont(forTextStyle: .callout)
    
    // text color
    static let versionTextColor: UIColor = .systemGray
    static let currentVersionReleaseDateTextColor: UIColor = .systemGray
    static let foldingButtonTextColor: UIColor = .systemBlue
    static let descriptionTextColor: UIColor = .label
    
}
