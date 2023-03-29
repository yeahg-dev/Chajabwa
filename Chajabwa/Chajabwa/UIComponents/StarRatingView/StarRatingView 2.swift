//
//  StarRatingView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/19.
//

import UIKit

struct StarRatingViewConfiguration {
    
    let starSize: Double
    let starMargin: CGFloat
    let tintColor: UIColor
    
}

class StarRatingView: UIView {
    
    private var rating: Double
    
    private let configuration: StarRatingViewConfiguration
    private let totalStarCount = 5
    private var viewSize = CGSize()
    
    init(rating: Double, configuration: StarRatingViewConfiguration) {
        self.rating = rating
        self.configuration = configuration
        super.init(frame: .zero)
        setStarLayers()
        improvePerformance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open var intrinsicContentSize: CGSize {
      return viewSize
    }
    
    func update(rating: Double) {
        if self.rating != rating {
            self.rating = rating
            setStarLayers()
        }
    }
    
    private func setStarLayers() {
        let layerConfiguration = StarLayerConfiugration(
            size: configuration.starSize,
            color: configuration.tintColor,
            margin: configuration.starMargin)
        let starLayers = StarLayer.createStarLayers(rating: rating, configuration: layerConfiguration)
        
        layer.sublayers = starLayers
        
        update(size: layerConfiguration.frameSize)
    }
    
    private func update(size: CGSize) {
        viewSize = size
        invalidateIntrinsicContentSize()
        frame.size = intrinsicContentSize
    }
    
    private func improvePerformance() {
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        isOpaque = true
      }

}
