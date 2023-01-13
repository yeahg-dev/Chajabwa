//
//  AppFolderTableViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/13.
//

import UIKit

class AppFolderTableViewCell: BaseTableViewCell {
    
    private let layoutGuide: UILayoutGuide = UILayoutGuide()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Design.iconImageViewCornerRadius
        imageView.layer.borderWidth = Design.iconImageViewBorderWidth
        imageView.layer.borderColor = Design.icomImageViewBorderColor
        return imageView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [folderNameLabel, savedAppCountLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = Design.labelStackViewSpacing
        return stackView
    }()
    
    private let folderNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.folderNameLabelFont
        label.textColor = Design.folderNameLabelFontColor
        label.textAlignment = .left
        return label
    }()

    private let savedAppCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.savedAppCountLabelFont
        label.textColor = Design.savedAppCountLabelFontColor
        return label
    }()
    
    func bind() {
        // 이미지 설정
        // name, count
        // checkmark
    }
    
    override func addSubviews() {
        contentView.addLayoutGuide(layoutGuide)
        contentView.addSubview(iconImageView)
        contentView.addSubview(labelStackView)
        configureUI()
    }
    
    private func configureUI() {
        self.tintColor = Design.cellTintColor
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            layoutGuide.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Design.contentViewPaddingLeading),
            layoutGuide.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Design.contentViewPaddingTop),
            layoutGuide.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Design.contentViewPaddingTrailing),
            layoutGuide.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Design.contentViewPaddingBottom),
            iconImageView.widthAnchor.constraint(
                equalToConstant: Design.iconImageViewWidth),
            iconImageView.heightAnchor.constraint(
                equalToConstant: Design.iconImageViewWidth),
            iconImageView.leadingAnchor.constraint(
                equalTo: layoutGuide.leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),
            labelStackView.centerYAnchor.constraint(
                equalTo: layoutGuide.centerYAnchor),
            labelStackView.leadingAnchor.constraint(
                equalTo: iconImageView.leadingAnchor,
                constant: Design.iconViewTrailingMargin),
            labelStackView.trailingAnchor.constraint(
                lessThanOrEqualTo: accessoryView!.leadingAnchor,
                constant: -Design.labelStackViewSpacing)
        ])
    }
    
}

private enum Design {
    
    static let contentViewPaddingLeading: CGFloat = 20
    static let contentViewPaddingTop: CGFloat = 15
    static let contentViewPaddingTrailing: CGFloat = 20
    static let contentViewPaddingBottom: CGFloat = 15
    
    static let iconViewTrailingMargin: CGFloat = 13
    
    static let labelStackViewSpacing: CGFloat = 5
    
    static let iconImageViewWidth: CGFloat = 60
    
    static let iconImageViewCornerRadius: CGFloat = 20
    static let icomImageViewBorderColor: CGColor = UIColor.systemGray4.cgColor
    static let iconImageViewBorderWidth: CGFloat = 0.5
    
    static let folderNameLabelFont: UIFont = .preferredFont(forTextStyle: .callout)
    static let savedAppCountLabelFont: UIFont = .preferredFont(forTextStyle: .callout)
    
    static let folderNameLabelFontColor: UIColor = .black
    static let savedAppCountLabelFontColor: UIColor = Color.mauveLavender
    static let cellTintColor: UIColor = .red
    
}
