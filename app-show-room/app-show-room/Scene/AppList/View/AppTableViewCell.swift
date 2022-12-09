//
//  AppTableViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/08.
//

import UIKit

class AppTableViewCell: UITableViewCell {
    
    private lazy var topStackView: UIStackView = {
       let stackView = UIStackView(
        arrangedSubviews: [iconAndLabelsStackView, bookmarkButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 18
        return stackView
    }()
    
    private lazy var iconAndLabelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, labelsStackView])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [nameLabel, descriptionLabel, ratingStackView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(
            frame: CGRect(
                origin: .zero,
                size: CGSize(
                    width: Design.iconImageViewBorderWidth,
                    height: Design.iconImageViewHeight)))
        imageView.layer.cornerRadius = Design.iconImageViewCornerRadius
        imageView.layer.borderWidth = Design.iconImageViewBorderWidth
        imageView.layer.borderColor = Design.icomImageViewBorderColor
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Design.titleLabelFont
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Design.descriptionLabelFont
        label.textColor = Design.descriptionLabelTextColor
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [averageStarRatingView, userRatingCountLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private let averageStarRatingView: StarRatingView = {
        let configuration = StarRatingViewConfiguration(
            starSize: Design.starSize,
            starMargin: Design.starMargin,
            tintColor: Design.starColor)
        let starRatingView = StarRatingView(rating: 0.0, configuration: configuration)
        return starRatingView
    }()
    
    private let userRatingCountLabel: UILabel = {
        let label = UILabel()
        label.font = Design.starRatingLabelFont
        label.textColor = Design.starRatingLabelTextColor
        label.textAlignment = .left
        return label
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton(
            frame: CGRect(origin: .zero, size: Design.bookmarkButtonSize))
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        return button
    }()
    
    private lazy var screenshotStackView: UIStackView = {
       let stackView = UIStackView(
        arrangedSubviews: [screenshotImageView1, screenshotImageView2, screenshotImageView3])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let screenshotImageView1 = ScreenshotImageView(frame: .zero)
    private let screenshotImageView2 = ScreenshotImageView(frame: .zero)
    private let screenshotImageView3 = ScreenshotImageView(frame: .zero)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubviews()
        self.setConstraints()
    }
    
    private func addSubviews() {
        self.contentView.addSubview(topStackView)
        self.contentView.addSubview(screenshotStackView)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Design.contentViewPadding),
            topStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Design.contentViewPadding),
            topStackView.bottomAnchor.constraint(
                equalTo: screenshotStackView.topAnchor,
                constant: -Design.defaultSpacing),
            screenshotStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Design.contentViewPadding),
            screenshotStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Design.contentViewPadding),
            screenshotStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Design.contentViewPadding),
            topStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Design.contentViewPadding)
        ])
    }
    
}

extension AppTableViewCell {
    
    // MARK: - Desigin
    
    private enum Design {
        
        // layer
        static let iconImageViewCornerRadius: CGFloat = 20
        static let icomImageViewBorderColor: CGColor = UIColor.systemGray4.cgColor
        static let iconImageViewBorderWidth: CGFloat = 0.5
        static let purchaseButtonCornerRadius: CGFloat = 13
        
        // font
        static let titleLabelFont: UIFont = .preferredFont(forTextStyle: .title3)
        static let descriptionLabelFont: UIFont = .preferredFont(forTextStyle: .subheadline)
        static let starRatingLabelFont: UIFont = .preferredFont(forTextStyle: .subheadline)
        
        // textColor
        static let descriptionLabelTextColor: UIColor = .gray
        static let starRatingLabelTextColor: UIColor = .systemGray5
        
        // starRatingView
        static let starSize: CGFloat = 13
        static let starMargin: CGFloat = 3
        static let starColor: UIColor = .gray
        
        // size
        static let bookmarkButtonSize: CGSize = .init(width: 40, height: 40)
        static let iconImageViewHeight: CGFloat = UIScreen.main.bounds.height * 0.1
        
        // padding
        static let contentViewPadding: CGFloat = 25
        static let defaultSpacing: CGFloat = 23
        
    }
    
}
