//
//  StarRatingView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/19.
//

import UIKit

class StarRatingView: UIView {
    
    private let starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private let rate: Double
    private let color: UIColor
    private let totalStarCount = 5
    
    init(frame: CGRect, rate: Double, color: UIColor) {
        self.rate = rate
        self.color = color
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        let starViews = makeStarViews(rate: rate, color: color)
        starViews.forEach { starView in
            starStackView.addSubview(starView)
        }
    
        addSubview(starStackView)
        
        NSLayoutConstraint.activate([
            starStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            starStackView.topAnchor.constraint(equalTo: self.topAnchor),
            starStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            starStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func makeStarViews(rate: Double, color: UIColor) -> [StarView] {
        var starViews: [StarView] = []
        let filledStarCount = Int(rate)
        
        for _ in 0..<filledStarCount {
            let filledStar = StarView(frame: .zero, size: 1, color: color)
            starViews.append(filledStar)
        }
        
        let emptyStarCount: Int
        let fractionalPart = rate - Double(filledStarCount)
        if fractionalPart == 0 {
            emptyStarCount = totalStarCount - filledStarCount
        } else {
            emptyStarCount = totalStarCount - filledStarCount - 1
            
            let partialStar = StarView(frame: .zero, size: fractionalPart, color: color)
            starViews.append(partialStar)
        }
        
        for _ in 0..<emptyStarCount {
            let emptyStar = StarView(frame: .zero, size: 0, color: color)
            starViews.append(emptyStar)
        }
        
        return starViews
    }
}
