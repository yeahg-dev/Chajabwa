//
//  ScreenshotGalleryDesign.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

protocol ScreenshotGalleryDesign {
    
    static var topSectionInset: CGFloat { get }
    static var bottomSectionInset: CGFloat { get }
    static var leadingSectionInset: CGFloat { get }
    static var trailingSectionInset: CGFloat { get }
    static var minimumLineSpacing: CGFloat { get }
    
    static var cellHeight: CGFloat { get }
    static var cellWidth: CGFloat { get }
}

enum EmbeddedInAppDetailSceneDesign: ScreenshotGalleryDesign {
    
    static let topSectionInset: CGFloat = 10
    static let bottomSectionInset: CGFloat = 10
    static let leadingSectionInset: CGFloat = 25
    static let trailingSectionInset: CGFloat = 25
    static let minimumLineSpacing: CGFloat = 15
    
    static let cellWidth: CGFloat = cellHeight * 0.56
    static let cellHeight: CGFloat = UIScreen.main.bounds.height * 0.55
}

enum EnlargedSceneDesign: ScreenshotGalleryDesign {
    
    static let topSectionInset: CGFloat = 50
    static let bottomSectionInset: CGFloat = 50
    static let leadingSectionInset: CGFloat = 25
    static let trailingSectionInset: CGFloat = 25
    static let minimumLineSpacing: CGFloat = 15
    
    static let cellWidth: CGFloat = cellHeight * 0.56
    static let cellHeight: CGFloat = UIScreen.main.bounds.height * 0.8
}
