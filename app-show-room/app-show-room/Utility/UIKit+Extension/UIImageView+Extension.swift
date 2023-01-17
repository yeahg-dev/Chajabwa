//
//  UIImageView+Extension.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

extension UIImageView {
    
    func setImage(
        with urlString: String?,
        defaultImage: UIImage)
    async throws -> CancellableTask?
    {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            print("nil이니깐 defaultImage")
            DispatchQueue.main.async {
                self.image = defaultImage
            }
            return nil
        }
        
        let imageCache = ImageCache()
        let cacheKey = urlString
        
        if let cachedImage = imageCache.getImage(of: cacheKey) {
            self.image = cachedImage
            return nil
        }
        
        return Task{
            if Task.isCancelled {
                self.image = defaultImage
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from:url)
                DispatchQueue.main.async {
                    guard let image = UIImage(data: data) else {
                        return }
                    self.image = image
                    imageCache.cache(image, of: cacheKey)
                }
            } catch {
                DispatchQueue.main.async {
                    self.image = defaultImage
                }
                return
            }
        }
    }
    
}

protocol CancellableTask {
    
    func cancelTask()
}

extension Task: CancellableTask {
    
    func cancelTask() {
        self.cancel()
    }
    
}
