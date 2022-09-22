//
//  StarView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/19.
//

import UIKit

class StarView: UIView {
    
    private let proportionOfFill: Double
    private let color: UIColor
    
    private let filledStarLayer = CALayer()
    private let outlinedStarLayer = CALayer()
    
    init(frame: CGRect, proportionOfFill: Double, color: UIColor) {
        self.proportionOfFill = proportionOfFill
        self.color = color
        super.init(frame: frame)
        configureLayers()
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayers() {
        layer.bounds = bounds

        outlinedStarLayer.contents = UIImage(
            systemName: "star")?
            .withTintColor(color)
            .cgImage
        outlinedStarLayer.anchorPoint = CGPoint()
        outlinedStarLayer.position = CGPoint()
        outlinedStarLayer.contentsGravity = CALayerContentsGravity.resizeAspect
        outlinedStarLayer.contentsScale = UIScreen.main.scale
        outlinedStarLayer.masksToBounds = true
        outlinedStarLayer.bounds = CGRect(origin: .zero, size: bounds.size)
        outlinedStarLayer.isOpaque = true
        
        filledStarLayer.contentsScale = UIScreen.main.scale
        filledStarLayer.position = CGPoint()
        filledStarLayer.anchorPoint = CGPoint()
        filledStarLayer.masksToBounds = true
        filledStarLayer.bounds = CGRect(origin: .zero, size: bounds.size)
        filledStarLayer.isOpaque = true
        filledStarLayer.contents = UIImage(
            systemName: "star.fill")?
            .withTintColor(color)
            .cgImage
        filledStarLayer.contentsGravity = CALayerContentsGravity.resizeAspect
        
        let filledStarContainerLayer = CALayer()
        filledStarContainerLayer.contentsScale = UIScreen.main.scale
        filledStarContainerLayer.anchorPoint = CGPoint()
        filledStarContainerLayer.masksToBounds = true
        filledStarContainerLayer.position = CGPoint()
        filledStarContainerLayer.bounds = CGRect(origin: .zero, size: bounds.size)
        filledStarContainerLayer.isOpaque = true
        filledStarContainerLayer.addSublayer(filledStarLayer)
        
        let parentLayer = CALayer()
        parentLayer.position = CGPoint()
        parentLayer.anchorPoint = CGPoint()
        parentLayer.contentsScale = UIScreen.main.scale
        parentLayer.bounds = CGRect(origin: .zero, size: bounds.size)

        parentLayer.addSublayer(outlinedStarLayer)
        parentLayer.addSublayer(filledStarContainerLayer)
        
        filledStarContainerLayer.bounds.size.width *= CGFloat(proportionOfFill)
        
        layer.addSublayer(parentLayer)
    }
}
