//
//  ScreenshotCollectionViewCellDesign.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/29.
//

import UIKit

protocol ScreenshotCollectionViewCellDesign {
    
    static var defaultImage: UIImage { get }
    static var cornerRadius: CGFloat { get }
    static var width: CGFloat { get }
    static var height: CGFloat { get }
}

enum ScreenShotCollectionViewCellStyle {

    enum Normal: ScreenshotCollectionViewCellDesign {
        
        static let defaultImage = UIImage(withBackground: .systemGray4)
        static let cornerRadius: CGFloat = 9
        static let width: CGFloat = 224
        static let height: CGFloat = 400
    }
    
    enum Large: ScreenshotCollectionViewCellDesign {
        
        static let defaultImage = UIImage(withBackground: .systemGray4)
        static let cornerRadius: CGFloat = 9
        static let width: CGFloat = 308
        static let height: CGFloat = 550
    }
    
}
