//
//  StarView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/19.
//

import UIKit

// filledStar.mask = maskLayer
// outlinedStar
// maskLayer

class StarView: UIView {
    
    private let size: Double
    private let color: UIColor
    
    private let filledStarLayer = CALayer()
    private let outlinedStarLayer = CALayer()
    
    init(frame: CGRect, size: Double, color: UIColor) {
        self.size = size
        self.color = color
        super.init(frame: frame)
        configureLayers()
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayers() {
        layer.addSublayer(outlinedStarLayer)
        layer.addSublayer(filledStarLayer)
        
//        outlinedStarLayer.frame = bounds
        outlinedStarLayer.contents = UIImage(
            named: "star")?
            .withTintColor(color)
            .cgImage
        
//        filledStarLayer.frame = bounds
        filledStarLayer.contents = UIImage(
            named: "star.fill")?
            .withTintColor(color)
            .cgImage
        filledStarLayer.bounds.size.width = CGFloat(size)
    }
}
