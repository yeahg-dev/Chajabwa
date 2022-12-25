//
//  SearchBackgroundView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/25.
//

import UIKit

class SearchBackgroundView: UIView {
    
    private let platformImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let countryLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "background")
        self.addSubview(platformImageView)
        self.addSubview(countryLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configurelayout()
    }
    
    override func draw(_ rect: CGRect) {
        let centerPoint = CGPoint(x: 0, y: rect.midY)
        let largeRadius = rect.height * 0.3
        let largeCirclePath = UIBezierPath(
            arcCenter: centerPoint,
            radius: largeRadius,
            startAngle: 3/2 * .pi,
            endAngle: 1/2 * .pi,
            clockwise: true)
        let largeCircleColor = UIColor(named: "largeCircle")!
        largeCircleColor.setFill()
        largeCirclePath.fill()
        let smallRadius = rect.height * 0.15
        let smallCirclePath = UIBezierPath(
            arcCenter: centerPoint,
            radius: smallRadius,
            startAngle: 3/2 * .pi,
            endAngle: 1/2 * .pi,
            clockwise: true)
        let smallCircleColor = UIColor(named: "smallCircle")!
        smallCircleColor.setFill()
        smallCirclePath.fill()
    }
    
    private func configurelayout() {
        let countryLabelX = frame.height * 0.3 * 3/4
        NSLayoutConstraint.activate([
            platformImageView.centerYAnchor.constraint(
                equalTo: self.centerYAnchor),
            platformImageView.centerXAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 30),
            countryLabel.centerYAnchor.constraint(
                equalTo: self.centerYAnchor),
            countryLabel.centerXAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: countryLabelX)
        ])
    }
    
}
