//
//  SignboardCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import UIKit

final class SignboardCollectionViewCell: BaseCollectionViewCell {
    
    private let design = SignboardCollectionViewCellDesign.self
    
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
        iconImageView.layer.cornerRadius = design.iconImageViewCornerRadius
        iconImageView.layer.borderColor = design.icomImageViewBorderColor
        iconImageView.layer.borderWidth = design.iconImageViewBorderWidth
        iconImageView.clipsToBounds = true
    }
    
    private func configureAppNameLabel() {
        appNameLabel.font = design.appNameLabelFont
        appNameLabel.lineBreakMode = .byTruncatingTail
        appNameLabel.numberOfLines = design.appNameLabelNumberOfLines
    }
    
    private func configureProviderLabel() {
        providerLabel.font = design.providerLabelFont
        providerLabel.textColor = design.appNameLabelTextColor
        providerLabel.numberOfLines = design.providerLabelNumberOfLines
    }
    
    private func configurePurchaseButton() {
        purchaseButton.backgroundColor = design.purchaseButtonBackgroundColor
        purchaseButton.layer.cornerRadius = design.purchaseButtonCornerRadius
        purchaseButton.titleLabel?.textColor = design.purchaseButtonTextColor
        purchaseButton.titleLabel?.font = design.purchaseButtonFont
    }
    
    private func configureShareButton() {
        let shareImage = design.shareButtonImage
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
            equalToConstant: design.iconImageViewHeight)
        heightAnchor.priority = .init(rawValue: 750)
        let widthAnchor = iconImageView.widthAnchor.constraint(
            equalToConstant: design.iconImageViewWidth)
        widthAnchor.priority = .init(rawValue: 1000)
        NSLayoutConstraint.activate([
            widthAnchor,
            heightAnchor,
            iconImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: design.paddingLeading),
            iconImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: design.paddingTop),
            iconImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -design.paddingBottom)
        ])
    }
    
    private func setConstraintsOfAppNameLabel() {
        NSLayoutConstraint.activate([
            appNameLabel.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: design.iconImageViewTrailingMargin),
            appNameLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: design.paddingTop),
            appNameLabel.trailingAnchor.constraint(
                greaterThanOrEqualTo: contentView.trailingAnchor,
                constant: -design.paddingTrailing),
        ])
    }
    
    private func setConstraintOfProviderLabel() {
        NSLayoutConstraint.activate([
            providerLabel.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: design.iconImageViewTrailingMargin),
            providerLabel.topAnchor.constraint(
                equalTo: appNameLabel.bottomAnchor,
                constant: design.providerLabelTopMargin),
            providerLabel.trailingAnchor.constraint(
                greaterThanOrEqualTo: contentView.trailingAnchor,
                constant: -design.paddingTrailing)
        ])
    }
    
    private func setContstraintOfPurchaseButton() {
        NSLayoutConstraint.activate([
            purchaseButton.heightAnchor.constraint(
                equalToConstant: design.purchaseButtonHeight),
            purchaseButton.widthAnchor.constraint(
                equalToConstant: design.purchaseButtonWidth),
            purchaseButton.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: design.iconImageViewTrailingMargin),
            purchaseButton.bottomAnchor.constraint(
                equalTo: iconImageView.bottomAnchor)
        ])
    }
    
    private func setConstraintOfShareButton() {
        NSLayoutConstraint.activate([
            shareButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -design.paddingTrailing),
            shareButton.bottomAnchor.constraint(
                equalTo: iconImageView.bottomAnchor)
        ])
    }
}

extension SignboardCollectionViewCell {
    
    private func fillIconImage(url: String?) {
        _ = iconImageView.setImage(
            with: url,
            defaultImage: design.defaultIconImage)
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
