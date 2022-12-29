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
        
        let task = Task{
            if Task.isCancelled {
                self.image = nil
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
        return task
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
