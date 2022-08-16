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
    static var leftSectionInset: CGFloat { get }
    static var rightSectionInset: CGFloat { get }
    static var minimumLineSpacing: CGFloat { get }
}

enum EmbeddedInAppDetailSceneDesign: ScreenshotGalleryDesign {
    
    static let topSectionInset: CGFloat = 10
    static let bottomSectionInset: CGFloat = 10
    static let leftSectionInset: CGFloat = 25
    static let rightSectionInset: CGFloat = 25
    static let minimumLineSpacing: CGFloat = 12
}

enum EnlargedSceneDesign: ScreenshotGalleryDesign {
    
    static let topSectionInset: CGFloat = 5
    static let bottomSectionInset: CGFloat = 20
    static let leftSectionInset: CGFloat = 12
    static let rightSectionInset: CGFloat = 12
    static let minimumLineSpacing: CGFloat = 6
}
