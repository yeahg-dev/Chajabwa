//
//  SignboardCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import UIKit

final class SignboardCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Design used in AppDetialView
    
    static let cellHeight = Design.height
    
    // MARK: - UIComponents
    private let iconImageView = UIImageView()
    private let appNameLabel = UILabel()
    private let providerLabel = UILabel()
    private let purchaseButton = UIButton(type: .custom)
    private let shareButton = UIButton(type: .system)
    
    override func addSubviews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(appNameLabel)
        contentView.addSubview(providerLabel)
        contentView.addSubview(purchaseButton)
        contentView.addSubview(shareButton)
    }
    
    override func configureSubviews() {
        configureUI()
    }
    
    override func setConstraints() {
        invalidateTranslateAutoResizingMasks(of: [
            iconImageView, appNameLabel, providerLabel, purchaseButton, shareButton, self.contentView
        ])
        setConstraintsOfContentView()
        setContratinsOfIconImageView()
        setConstraintsOfAppNameLabel()
        setConstraintOfProviderLabel()
        setContstraintOfPurchaseButton()
        setConstraintOfShareButton()
    }
    
   func bind(model: AppDetailViewModel.Item) {
        if case let .signBoard(signBoard) = model {
            fillIconImage(url: signBoard.iconImageURL)
            fillAppNameLabel(name: signBoard.name)
            fillProviderLabel(provider: signBoard.provider)
            fillPurcahseButton(price: signBoard.price)
        }
        
    }
    
    private func configureUI() {
        configureIconImageView()
        configureAppNameLabel()
        configureProviderLabel()
        configurePurchaseButton()
        configureShareButton()
    }
    
}

// MARK: - Design UIComponents

extension SignboardCollectionViewCell {
    
    private func configureIconImageView() {
        iconImageView.layer.cornerRadius = Design.iconImageViewCornerRadius
        iconImageView.layer.borderColor = Design.icomImageViewBorderColor
        iconImageView.layer.borderWidth = Design.iconImageViewBorderWidth
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill
    }
    
    private func configureAppNameLabel() {
        appNameLabel.font = Design.appNameLabelFont
        appNameLabel.lineBreakMode = .byTruncatingTail
        appNameLabel.textColor = Design.appNameLabelTextColor
        appNameLabel.numberOfLines = Design.appNameLabelNumberOfLines
    }
    
    private func configureProviderLabel() {
        providerLabel.font = Design.providerLabelFont
        providerLabel.textColor = Design.appNameLabelTextColor
        providerLabel.numberOfLines = Design.providerLabelNumberOfLines
        providerLabel.lineBreakMode = .byTruncatingTail
    }
    
    private func configurePurchaseButton() {
        purchaseButton.backgroundColor = Design.purchaseButtonBackgroundColor
        purchaseButton.layer.cornerRadius = Design.purchaseButtonCornerRadius
        purchaseButton.titleLabel?.textColor = Design.purchaseButtonTextColor
        purchaseButton.titleLabel?.font = Design.purchaseButtonFont
        purchaseButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    private func configureShareButton() {
        let shareImage = Design.shareButtonImage
        shareButton.setImage(shareImage, for: .normal)
    }
    
}

// MARK: - configure layout

extension SignboardCollectionViewCell {
    
    private func setConstraintsOfContentView() {
        let widthAnchor = contentView.widthAnchor.constraint(
            equalToConstant: UIScreen.main.bounds.width)
        widthAnchor.priority = .defaultHigh
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            widthAnchor
        ])
    }
    
    private func setContratinsOfIconImageView() {
        let heightAnchor = iconImageView.heightAnchor.constraint(
            equalToConstant: Design.iconImageViewHeight)
        heightAnchor.priority = .init(rawValue: 750)
        let widthAnchor = iconImageView.widthAnchor.constraint(
            equalToConstant: Design.iconImageViewWidth)
        widthAnchor.priority = .init(rawValue: 1000)
        NSLayoutConstraint.activate([
            widthAnchor,
            heightAnchor,
            iconImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Design.paddingLeading),
            iconImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Design.paddingTop),
            iconImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Design.paddingBottom)
        ])
    }
    
    private func setConstraintsOfAppNameLabel() {
        NSLayoutConstraint.activate([
            appNameLabel.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: Design.iconImageViewTrailingMargin),
            appNameLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Design.paddingTop),
            appNameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Design.paddingTrailing),
        ])
    }
    
    private func setConstraintOfProviderLabel() {
        NSLayoutConstraint.activate([
            providerLabel.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: Design.iconImageViewTrailingMargin),
            providerLabel.topAnchor.constraint(
                equalTo: appNameLabel.bottomAnchor,
                constant: Design.providerLabelTopMargin),
            providerLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: -Design.paddingTrailing)
        ])
    }
    
    private func setContstraintOfPurchaseButton() {
        NSLayoutConstraint.activate([
            purchaseButton.heightAnchor.constraint(
                equalToConstant: Design.purchaseButtonHeight),
            purchaseButton.widthAnchor.constraint(
                equalToConstant: Design.purchaseButtonWidth),
            purchaseButton.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: Design.iconImageViewTrailingMargin),
            purchaseButton.bottomAnchor.constraint(
                equalTo: iconImageView.bottomAnchor)
        ])
    }
    
    private func setConstraintOfShareButton() {
        NSLayoutConstraint.activate([
            shareButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Design.paddingTrailing),
            shareButton.bottomAnchor.constraint(
                equalTo: iconImageView.bottomAnchor)
        ])
    }
}

extension SignboardCollectionViewCell {
    
    private func fillIconImage(url: String?) {
        Task {
            _ = try await iconImageView.setImage(
                with: url,
                defaultImage: Design.defaultIconImage)
        }
    }
    
    private func fillAppNameLabel(name: String?) {
        appNameLabel.text = name
    }
    
    private func fillProviderLabel(provider: String?) {
        providerLabel.text = provider
    }
    
    private func fillPurcahseButton(price: String?) {
        purchaseButton.setTitle(price, for: .normal)
    }
    
}

private enum Design {
    
    // padding, margin
    static let paddingLeading = AppDetailCollectionViewCellDesign.paddingLeading
    static let paddingTop: CGFloat = 0
    static let paddingBottom = AppDetailCollectionViewCellDesign.paddingBottom
    static let paddingTrailing = AppDetailCollectionViewCellDesign.paddingTrailing
    
    static let iconImageViewTrailingMargin: CGFloat = 15
    static let providerLabelTopMargin: CGFloat = 5
    
    // size
    static let width = UIScreen.main.bounds.width
    static let height = paddingTop + iconImageViewHeight + paddingBottom
    static let iconImageViewWidth = UIScreen.main.bounds.width * 0.3
    static let iconImageViewHeight = iconImageViewWidth
    static let purchaseButtonWidth: CGFloat = 70
    static let purchaseButtonHeight: CGFloat = 25
    static let shareButtonWidth: CGFloat = 18
    static let shareButtonHeight: CGFloat = 10
    
    // border
    static let iconImageViewCornerRadius: CGFloat = 20
    static let icomImageViewBorderColor: CGColor = UIColor.systemGray4.cgColor
    static let iconImageViewBorderWidth: CGFloat = 0.5
    static let purchaseButtonCornerRadius: CGFloat = 5
    
    // numberOfLines
    static let appNameLabelNumberOfLines: Int = 2
    static let providerLabelNumberOfLines: Int = 1

    // font
    static let appNameLabelFont: UIFont = .boldSystemFont(ofSize: 22)
    static let providerLabelFont: UIFont = .preferredFont(forTextStyle: .callout)
    static let purchaseButtonFont: UIFont = .preferredFont(forTextStyle: .footnote)
    
    // image
    static let shareButtonImage = UIImage(
        systemName: "square.and.arrow.up")?
        .withTintColor(Design.shareButtonTintColor, renderingMode: .alwaysOriginal)
    static let defaultIconImage = UIImage(withBackground: .systemGray4)
    
    // textColor
    static let appNameLabelTextColor: UIColor = .black
    static let purchaseButtonTextColor: UIColor = .white
    
    // backgroundColor
    static let purchaseButtonBackgroundColor: UIColor = Colors.blueGreen.color
    
    // tintColor
    static let shareButtonTintColor = Colors.blueGreen.color
}
