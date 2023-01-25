//
//  RecentSearchKeywordTableViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/02.
//

import UIKit

final class RecentSearchKeywordTableViewCell: BaseTableViewCell {
    
    private let clockIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let clockImage = UIImage(systemName: "clock.arrow.circlepath")?
            .withTintColor(.gray, renderingMode: .alwaysOriginal)
        imageView.image = clockImage
        return imageView
    }()
    
    private lazy var keywordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [keywordLabel, countryFlagLabel, platformImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.setCustomSpacing(5, after: keywordLabel)
        return stackView
    }()
    
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = Design.keywordLabelTextColor
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let countryFlagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .callout)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let platformImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .callout)
        label.textAlignment = .right
        label.textColor = .gray
        return label
    }()
    
    func bind(_ viewModel: RecentSearchKeywordCellModel) {
        keywordLabel.text = viewModel.keyword
        countryFlagLabel.text = viewModel.countryFlag
        platformImageView.image = viewModel.softwareIcon
        dateLabel.text = viewModel.date
    }
    
    override func addSubviews() {
        contentView.addSubview(clockIconImageView)
        contentView.addSubview(keywordStackView)
        contentView.addSubview(dateLabel)
        configureUI()
    }
    
    private func configureUI() {
        backgroundColor = Design.backgroundColor
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = Design.selectedBackgroundColor
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            clockIconImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Design.paddingLeading),
            clockIconImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Design.paddingTop),
            clockIconImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Design.paddingBottom),
            clockIconImageView.trailingAnchor.constraint(
                equalTo: keywordStackView.leadingAnchor,
                constant: -Design.clockImageViewRightMargin),
            clockIconImageView.widthAnchor.constraint(
                equalTo: clockIconImageView.heightAnchor,
                multiplier: 1),
            keywordStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Design.paddingTop),
            keywordStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Design.paddingBottom),
            keywordStackView.trailingAnchor.constraint(
                lessThanOrEqualTo: dateLabel.leadingAnchor,
                constant: -5),
            platformImageView.widthAnchor.constraint(
                equalToConstant: Design.platformImageViewWidth),
            platformImageView.heightAnchor.constraint(
                equalToConstant: Design.platformImageViewWidth),
            dateLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Design.paddingTrailing),
            dateLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor)
        ])
    }
    
}

private enum Design {
    
    static let paddingLeading: CGFloat = 25
    static let paddingTrailing: CGFloat = 25
    static let paddingTop: CGFloat = 15
    static let paddingBottom: CGFloat = 15
    static let platformImageViewWidth: CGFloat = 27
    
    static let clockImageViewRightMargin: CGFloat = 9
    
    static let keywordLabelTextColor: UIColor = .black
    static let backgroundColor: UIColor = .clear
    static let selectedBackgroundColor: UIColor = Color.skyBlue
    
}
