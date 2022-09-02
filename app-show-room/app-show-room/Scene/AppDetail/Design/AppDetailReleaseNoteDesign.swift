//
//  AppDetailReleaseNoteDesign.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/02.
//

import UIKit

enum AppDetailReleaseNoteDesign {
    
    // margin, spacing
    static let leadingMargin = CGFloat(25)
    static let topMargin = CGFloat(5)
    static let trailingMargin = CGFloat(25)
    static let bottomMargin = CGFloat(5)
    static let spacing = CGFloat(5)
    
    // size
    static let foldingButtonWidth = CGFloat(100)
    static let foldingButtonHeight = CGFloat(25)
    
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
