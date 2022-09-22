//
//  LargeScreenshotCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/29.
//

import UIKit

final class LargeScreenshotCollectionViewCell: ScreenShotCollectionViewCell {
    
    override var design: ScreenshotCollectionViewCellDesign.Type {
        return ScreenShotCollectionViewCellStyle.Large.self
    }
    
}
