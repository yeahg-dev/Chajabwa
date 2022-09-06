//
//  SummaryCollectionViewCellDesign.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/04.
//

import UIKit

enum SummaryCollectionViewCellDesign {
    
    // padding
    static let paddingLeading: CGFloat = 5
    static let paddingTrailing: CGFloat = 5
    
    // size
    static let width: CGFloat = 100
    static let height: CGFloat = 70
    static let separatorWidth: CGFloat = 0.3
    static let separatorHeight: CGFloat = height * 0.6
    
    // font
    static let primaryTextLabelFont: UIFont = .preferredFont(forTextStyle: .caption1)
    static let secondaryTextLaelFont: UIFont = .preferredFont(forTextStyle: .caption1)
    
    // color
    static let primaryTextColor: UIColor = .gray
    static let secondaryTextColor: UIColor = .gray
    static let symbolImageTintColor: UIColor = .gray
    static let separatorColor: CGColor = UIColor.systemGray3.cgColor
    
    // symbolConfiguration
    static let preferredSymbolConfiguration: UIImage.SymbolConfiguration = .init(font: .preferredFont(forTextStyle: .title2), scale: .large)
    
}
