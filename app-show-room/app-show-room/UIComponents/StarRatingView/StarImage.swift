//
//  StarImage.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/22.
//

import UIKit

protocol StarImage {
    
    static var filledStar: UIImage? { get }
    static var emptyStar: UIImage? { get }
    
}

struct SystemStarImage: StarImage {
    
    static var filledStar: UIImage? {
        return UIImage(systemName: "star.fill")
    }
    
    static var emptyStar: UIImage? {
        return UIImage(systemName: "star")
    }
}
