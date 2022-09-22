//
//  StarLayer.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/22.
//

import UIKit

struct StarLayerConfiugration {
    
    private let image: StarImage.Type = SystemStarImage.self
    
    let numberOfStar: Double = 5
    let size: Double
    let color: UIColor
    let margin: Double
    
    init(size: Double, color: UIColor = .systemBlue , margin: Double) {
        self.size = size
        self.color = color
        self.margin = margin
    }
    
    var filledStarImage: UIImage? {
        return image.filledStar
    }
    
    var emptyStarImage: UIImage? {
        return image.emptyStar
    }
    
    var frameSize: CGSize {
        let width = size * numberOfStar + margin * (numberOfStar - 1)
        let height = size
        return CGSize(width: width, height: height)
    }
    
}

final class StarLayer {
    
    static func createStarLayers(rating: Double, configuration: StarLayerConfiugration) -> [CALayer] {
        var starLayers = [CALayer]()
        
        let numberOfFilledStar = Int(floor(rating))
        for _ in 0..<numberOfFilledStar {
            let filledStar = StarLayer.createStarLayer(isFilled: true, configuration: configuration)
            starLayers.append(filledStar)
        }
        
        let remainder = rating - Double(numberOfFilledStar)
        if remainder > 0 {
            let partialStar = StarLayer.createPartialStarLayer(proportionToFill: remainder, configuration: configuration)
            starLayers.append(partialStar)
        }
        
        let numberOfEmptyStar = 5 - ceil(rating)
        for _ in 0..<Int(numberOfEmptyStar) {
            let emptyStar = StarLayer.createStarLayer(isFilled: false, configuration: configuration)
            starLayers.append(emptyStar)
        }
        
        return positionStarLayers(starLayers, margin: configuration.margin)
    }
    
    static func createStarLayer(isFilled: Bool, configuration: StarLayerConfiugration) -> CALayer {
        let starImage = isFilled ? configuration.filledStarImage?.cgImage : configuration.emptyStarImage?.cgImage
        
        let layer = CALayer()
        layer.backgroundColor = configuration.color.cgColor
        layer.anchorPoint = CGPoint()
        layer.bounds.size = CGSize(width: configuration.size, height: configuration.size)
        layer.isOpaque = true
        
        let maskLayer = CALayer()
        maskLayer.frame = layer.bounds
        maskLayer.contents = starImage
        maskLayer.contentsGravity = CALayerContentsGravity.resizeAspect
        
        layer.mask = maskLayer
        
        return layer
    }
    
    static func createPartialStarLayer(proportionToFill: Double, configuration: StarLayerConfiugration) -> CALayer {
        let filledStar = StarLayer.createStarLayer(isFilled: true, configuration: configuration)
        let emptyStar = StarLayer.createStarLayer(isFilled: false, configuration: configuration)
        
        let filledStarContainerLayer = CALayer()
        filledStarContainerLayer.contentsScale = UIScreen.main.scale
        filledStarContainerLayer.anchorPoint = CGPoint()
        filledStarContainerLayer.masksToBounds = true
        filledStarContainerLayer.bounds.size = CGSize(width: configuration.size, height: configuration.size)
        filledStarContainerLayer.isOpaque = true
        filledStarContainerLayer.addSublayer(filledStar)
        
        let parentLayer = CALayer()
        parentLayer.contentsScale = UIScreen.main.scale
        parentLayer.bounds.size = CGSize(width: configuration.size, height: configuration.size)
        parentLayer.anchorPoint = CGPoint()
        parentLayer.addSublayer(emptyStar)
        parentLayer.addSublayer(filledStarContainerLayer)
        
        filledStarContainerLayer.bounds.size.width *= CGFloat(proportionToFill)
        
        return parentLayer
    }
    
    static func positionStarLayers(_ layers: [CALayer], margin: Double) -> [CALayer] {
        var positionX: CGFloat = 0
        
        let positionedLayers = layers.map { (layer) -> CALayer in
            layer.position.x = positionX
            positionX += layer.bounds.width + CGFloat(margin)
            return layer
        }
        
        return positionedLayers
    }
    
}
