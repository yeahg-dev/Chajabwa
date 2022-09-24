//
//  RatingTypeSummaryView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/20.
//

import UIKit

final class RatingTypeSummaryView: UIView {
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [primaryTextLabel, symbolImageView, starRatingView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Design.stackViewSpacing
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let primaryTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textAlignment = .center
        label.textColor = Design.primaryTextColor
        label.numberOfLines = 1
        return label
    }()
    
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = Design.symbolImageSymbolConfigruation
        imageView.tintColor = Design.symbolImageTintColor
        return imageView
    }()
    
    private let starRatingView: StarRatingView = {
        let configuration = StarRatingViewConfiguration(
            starSize: Design.starSize,
            starMargin: Design.starMargin,
            tintColor: Design.starColor)
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

// MARK: - Design

private enum Design {
    
    // spacing
    static let stackViewSpacing: CGFloat = 3
    
    // color
    static let primaryTextColor: UIColor = .gray
    static let symbolImageTintColor: UIColor = .gray
    static let starColor: UIColor = .gray
    
    // font
    static let primaryTextFont: UIFont = .preferredFont(forTextStyle: .caption1)
    static let symbolImageSymbolConfigruation = UIImage.SymbolConfiguration.init(font: .preferredFont(forTextStyle: .title2), scale: .large)
    
    // star
    static let starSize: CGFloat = 15
    static let starMargin: CGFloat = 3
    
}
