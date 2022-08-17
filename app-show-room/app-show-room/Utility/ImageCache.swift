//
//  ImageCache.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

final class ImageCache {
    
    static let shared = NSCache<NSString, UIImage>()
    
    func cache(_ image: UIImage, of cacheKey: String) {
        ImageCache.shared.setObject(image, forKey: cacheKey as NSString)
    }
    
    func getImage(of cacheKey: String) -> UIImage? {
        return ImageCache.shared.object(forKey: cacheKey as NSString)
    }
    
}
