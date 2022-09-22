//
//  StarRatingView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/19.
//

import UIKit

struct StarRatingViewConfiguration {
    
    let starSize: CGSize
    let starMargin: CGFloat
    let tintColor: UIColor
    
    func starRatingViewSize(of totalStarCount: Int) -> CGSize {
        let width: CGFloat = (starSize.width * CGFloat(totalStarCount)) + starMargin * CGFloat(4)
        let height = starSize.height
        return CGSize(width: width, height: height)
    }
    
}

class StarRatingView: UIView {
    
    private lazy var starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = configuration.starMargin
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let configuration: StarRatingViewConfiguration
    private var rating: Double

    private let totalStarCount = 5
    private var starViews: [StarView] = []
    
    init(rating: Double, configuration: StarRatingViewConfiguration) {
        self.rating = rating
        self.configuration = configuration
        super.init(frame: .zero)
        updateStarViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(rating: Double) {
        if self.rating != rating {
            self.rating = rating
            starViews.forEach { starView in
                starStackView.removeArrangedSubview(starView)
            }
            updateStarViews()
        }
    }
    
    private func updateStarViews() {
        starViews = makeStarViews(rate: rating, configuration: configuration)
        starViews.forEach { starView in
            starStackView.addArrangedSubview(starView)
        }
        self.frame.size = configuration.starRatingViewSize(of: totalStarCount)
        self.bounds.size = configuration.starRatingViewSize(of: totalStarCount)
    }
    
    override var intrinsicContentSize: CGSize {
        return configuration.starRatingViewSize(of: totalStarCount)
    }
    
    private func configureConstraints() {
        addSubview(starStackView)
        NSLayoutConstraint.activate([
            starStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            starStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func makeStarViews(rate: Double, configuration: StarRatingViewConfiguration) -> [StarView] {
        var starViews: [StarView] = []
        let filledStarCount = Int(rate)
        
        for _ in 0..<filledStarCount {
            let filledStar = StarView(frame: CGRect(origin: .zero, size: configuration.starSize), proportionOfFill: 1, color: configuration.tintColor)
            starViews.append(filledStar)
        }
        
        let emptyStarCount: Int
        let fractionalPart = rate - Double(filledStarCount)
        if fractionalPart == 0 {
            emptyStarCount = totalStarCount - filledStarCount
        } else {
            emptyStarCount = totalStarCount - filledStarCount - 1
            
            let partialStar = StarView(frame: CGRect(origin: .zero, size: configuration.starSize), proportionOfFill: fractionalPart, color: configuration.tintColor)
            starViews.append(partialStar)
        }
        
        for _ in 0..<emptyStarCount {
            let emptyStar = StarView(frame: CGRect(origin: .zero, size: configuration.starSize), proportionOfFill: 0, color: configuration.tintColor)
            starViews.append(emptyStar)
        }
        
        return starViews
    }
}
