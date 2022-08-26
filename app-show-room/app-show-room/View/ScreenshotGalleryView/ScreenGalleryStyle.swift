//
//  ScreenGalleryStyle.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/26.
//

import Foundation

enum ScreenshotGalleryStyle {
    
    case embeddedInAppDetailScene
    case enlarged
    
    var design: ScreenshotGalleryDesign.Type {
        switch self {
        case .embeddedInAppDetailScene:
            return EmbeddedInAppDetailSceneDesign.self
        case .enlarged:
            return EnlargedSceneDesign.self
        }
    }
}
