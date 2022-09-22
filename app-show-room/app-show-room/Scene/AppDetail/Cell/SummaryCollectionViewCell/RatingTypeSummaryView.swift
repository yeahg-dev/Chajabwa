//
//  RatingTypeSummaryView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/20.
//

import UIKit

enum SecondaryImageTypeSummaryViewDesign {
    
    // padding
    static let paddingLeading: CGFloat = 5
    static let paddingTrailing: CGFloat = 5
    
    // size
    static let width: CGFloat = 100
    static let height: CGFloat = 70
    static let separatorWidth: CGFloat = 0.3
    static let separatorHeight: CGFloat = height * 0.6
    
    // font
    static let primaryTextLabelFont: UIFont = .preferredFont(forTextStyle: .caption1)
    static let secondaryTextLaelFont: UIFont = .preferredFont(forTextStyle: .caption1)
    
    // color
    static let primaryTextColor: UIColor = .gray
    static let secondaryTextColor: UIColor = .gray
    static let symbolImageTintColor: UIColor = .gray
    static let separatorColor: CGColor = UIColor.systemGray3.cgColor
    
    // symbolConfiguration
    static let preferredSymbolConfiguration: UIImage.SymbolConfiguration = .init(font: .preferredFont(forTextStyle: .title2), scale: .large)
    
}


final class RatingTypeSummaryView: UIView {
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [primaryTextLabel, symbolImageView, starRatingView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private let primaryTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = .init(font: .preferredFont(forTextStyle: .title2), scale: .large)
        imageView.tintColor = .gray
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return imageView
    }()
    
    private let starRatingView: StarRatingView = {
        let configuration = StarRatingViewConfiguration(
            starSize: 15,
            starMargin: 3,
            tintColor: .gray)
        let starRatingView = StarRatingView(rating: 0.0, configuration: configuration)
        return starRatingView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(primaryText: String?, symbolImage: UIImage?, rating: Double?) {
        primaryTextLabel.text = primaryText
        symbolImageView.image = symbolImage
        starRatingView.update(rating: rating ?? 0.0)
    }
    
    private func configureConstraints() {
        addSubview(containerStackView)
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}
