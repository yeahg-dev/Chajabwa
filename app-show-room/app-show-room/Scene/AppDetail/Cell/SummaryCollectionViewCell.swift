//
//  SummaryCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import UIKit

final class SummaryCollectionViewCell: BaseCollectionViewCell {
    
    private let design = SummaryCollectionViewCellDesign.self
    
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
        if case let .summary(summary) = model {
            fillIconImage(url: summary.iconImageURL)
            fillAppNameLabel(name: summary.name)
            fillProviderLabel(provider: summary.provider)
            fillPurcahseButton(price: summary.price)
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

extension SummaryCollectionViewCell {
    
    private func configureIconImageView() {
        iconImageView.layer.cornerRadius = 20
        iconImageView.clipsToBounds = true
    }
    
    private func configureAppNameLabel() {
        appNameLabel.font = design.appNameLabelFont
        appNameLabel.lineBreakMode = .byTruncatingTail
        appNameLabel.numberOfLines = 2
    }
    
    private func configureProviderLabel() {
        providerLabel.font = design.providerLabelFont
        providerLabel.textColor = .gray
        providerLabel.numberOfLines = 1
    }
    
    private func configurePurchaseButton() {
        purchaseButton.backgroundColor = .systemBlue
        purchaseButton.layer.cornerRadius = 10
        purchaseButton.titleLabel?.textColor = .white
        purchaseButton.titleLabel?.font = design.purchaseButtonFont
    }
    
    private func configureShareButton() {
        let shareImage = design.shareButtonImage
        shareButton.titleLabel?.textColor = .white
        shareButton.titleLabel?.textAlignment = .center
        shareButton.setImage(shareImage, for: .normal)
    }
    
}

// MARK: - configure layout

extension SummaryCollectionViewCell {
    
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
                constant: design.leadingMargin),
            iconImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: design.topMargin),
            iconImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: design.bottomMargin * -1)
        ])
    }
    
    private func setConstraintsOfAppNameLabel() {
        NSLayoutConstraint.activate([
            appNameLabel.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: design.iconImageViewTrailingMargin),
            appNameLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: design.topMargin),
            appNameLabel.trailingAnchor.constraint(
                greaterThanOrEqualTo: contentView.trailingAnchor,
                constant: design.trailingMargin * -1),
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
                constant: design.trailingMargin * -1)
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
                constant: design.trailingMargin * -1),
            shareButton.bottomAnchor.constraint(
                equalTo: iconImageView.bottomAnchor)
        ])
    }
}

extension SummaryCollectionViewCell {
    
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
