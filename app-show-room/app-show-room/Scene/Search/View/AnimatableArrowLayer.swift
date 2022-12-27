//
//  AnimatableArrowLayer.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/27.
//

import UIKit

final class AnimatableArrowLayer: CAShapeLayer {
    
    private let centerPoint: CGPoint
    private let pathRadius: CGFloat
    private var startAngle: CGFloat? = 1.5 * .pi
    
    override init(layer: Any) {
        centerPoint = (layer as! AnimatableArrowLayer).centerPoint
        pathRadius = (layer as! AnimatableArrowLayer).pathRadius
        super.init(layer: layer)
    }
    
    init(center: CGPoint, radius: CGFloat) {
        centerPoint = center
        pathRadius = radius
        super.init()
        let arrowImage = UIImage(named: "arrow")!
        contents = arrowImage.cgImage
        bounds = CGRect(
            x: 0.0,
            y: 0.0,
            width: arrowImage.size.width,
            height: arrowImage.size.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPosition(_ start: CGFloat) {
        self.startAngle = start
        let initialPosition = CAKeyframeAnimation(keyPath: "position")
        let postionPath = UIBezierPath(
            arcCenter: centerPoint,
            radius: pathRadius,
            startAngle: start,
            endAngle: start,
            clockwise: true)
        initialPosition.path = postionPath.cgPath
        initialPosition.fillMode = .forwards
        initialPosition.isRemovedOnCompletion = false

        self.position = postionPath.currentPoint
    }
    
    func animate(from start: CGFloat?, to end: CGFloat) {
        if startAngle == nil {
            startAngle = start
        }
        let clockwise = (startAngle! < end) ? true : false
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        let arcPath = UIBezierPath(
            arcCenter: centerPoint,
            radius: pathRadius,
            startAngle: startAngle!,
            endAngle: end,
            clockwise: clockwise)
        positionAnimation.path = arcPath.cgPath
        positionAnimation.timingFunction = .init(name: CAMediaTimingFunctionName.easeInEaseOut)
        positionAnimation.isAdditive = true
        positionAnimation.duration = 0.5
        positionAnimation.fillMode = .forwards
        positionAnimation.isRemovedOnCompletion = false
        if clockwise {
            positionAnimation.rotationMode = .rotateAuto
        } else {
            positionAnimation.rotationMode = .rotateAutoReverse
        }
        let group = CAAnimationGroup()
        group.animations = [positionAnimation]
        
        add(group, forKey: nil)
        self.position = arcPath.currentPoint
        self.transform = CATransform3DMakeRotation(end - 3/2 * .pi , 0.0, 0.0, 1.0)
    
        startAngle = end
    }
    
}
