//
//  AppDetailSummaryCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import UIKit

private enum Design {
    
    // margin
    static let topMargin = CGFloat(0)
    static let bottomMargin = CGFloat(20)
    static let trailingMargin = CGFloat(25)
    static let iconImageViewLeadingMargin = CGFloat(25)
    static let iconImageViewTrailingMargin = CGFloat(10)
    static let providerLabelTopMargin = CGFloat(7)
    static let shareButtonWidth = CGFloat(18)
    static let shareButtonHeight = CGFloat(10)
    
    // size
    static let purchaseButtonWidth = CGFloat(50)
    static let purchaseButtonHeight = CGFloat(25)
    
    // font
    static let appNameLabelFont: UIFont = .boldSystemFont(ofSize: 22)
    static let providerLabelFont: UIFont = .preferredFont(forTextStyle: .callout)
    static let purchaseButtonFont: UIFont = .preferredFont(forTextStyle: .callout)
    
    // image
    static let shareButtonImage = UIImage(
        systemName: "square.and.arrow.up")?.withTintColor(.systemBlue)
    static let defaultIconImage = UIImage(withBackground: .systemGray4)
}

final class AppDetailSummaryCollectionViewCell: BaseAppDetailCollectionViewCell {
    
    override class var height: CGFloat {
        UIScreen.main.bounds.height * 0.2 }
    
    // MARK: - UIComponents
    private let iconImageView = UIImageView()
    private let appNameLabel = UILabel()
    private let providerLabel = UILabel()
    private let purchaseButton = UIButton(type: .custom)
    private let shareButton = UIButton(type: .system)

    override func configureSubviews() {
        self.designComponents()
        self.addSubviews()
        self.setConstraints()
    }
    
    override func addSubviews() {
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(appNameLabel)
        self.contentView.addSubview(providerLabel)
        self.contentView.addSubview(purchaseButton)
        self.contentView.addSubview(shareButton)
    }
    
    override func setConstraints() {
        self.invalidateTranslateAutoResizingMasks(of: [
            iconImageView, appNameLabel, providerLabel, purchaseButton, shareButton
        ])
        self.setContratinsOfIconImageView()
        self.setConstraintsOfAppNameLabel()
        self.setConstraintOfProviderLabel()
        self.setContstraintOfPurchaseButton()
        self.setConstraintOfShareButton()
    }

    override func bind(model: BaseAppDetailCollectionViewCellModel) {
        self.fillIconImage(url: model.iconImageURL)
        self.fillAppNameLabel(name: model.name)
        self.fillProviderLabel(provider: model.provider)
        self.fillPurcahseButton(price: model.price)
    }
    
    private func designComponents() {
        self.designIconImageView()
        self.designAppNameLabel()
        self.designProviderLabel()
        self.designPurchaseButton()
        self.designShareButton()
    }
    
}

// MARK: - Design UIComponents

extension AppDetailSummaryCollectionViewCell {
    
    private func designIconImageView() {
        self.iconImageView.layer.cornerRadius = 20
        self.iconImageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(
            equalTo: iconImageView.heightAnchor,
            multiplier: 1)])
    }
    
    private func designAppNameLabel() {
        self.appNameLabel.font = Design.appNameLabelFont
        self.appNameLabel.lineBreakMode = .byTruncatingTail
        self.appNameLabel.numberOfLines = 2
    }
    
    private func designProviderLabel() {
        self.providerLabel.font = Design.providerLabelFont
        self.providerLabel.textColor = .gray
        self.providerLabel.numberOfLines = 1
    }
    
    private func designPurchaseButton() {
        self.purchaseButton.backgroundColor = .systemBlue
        self.purchaseButton.layer.cornerRadius = 10
        self.purchaseButton.titleLabel?.textColor = .white
        self.purchaseButton.titleLabel?.font = Design.purchaseButtonFont
        NSLayoutConstraint.activate([
            self.purchaseButton.heightAnchor.constraint(
                equalToConstant: Design.purchaseButtonHeight),
            self.purchaseButton.widthAnchor.constraint(
                equalToConstant: Design.purchaseButtonWidth)
        ])
    }
    
    private func designShareButton() {
        let shareImage = Design.shareButtonImage
        self.shareButton.titleLabel?.textColor = .white
        self.shareButton.titleLabel?.textAlignment = .center
        self.shareButton.setImage(shareImage, for: .normal)
    }
    
}

// MARK: - Set Constraints for UIComponents

extension AppDetailSummaryCollectionViewCell {
 
    private func setContratinsOfIconImageView() {
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: Design.iconImageViewLeadingMargin),
            iconImageView.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: Design.topMargin),
            iconImageView.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: Design.bottomMargin * -1)
        ])
    }
    
    private func setConstraintsOfAppNameLabel() {
        NSLayoutConstraint.activate([
            appNameLabel.leadingAnchor.constraint(
                equalTo: self.iconImageView.trailingAnchor,
                constant: Design.iconImageViewTrailingMargin),
            appNameLabel.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: Design.topMargin)
        ])
    }
    
    private func setConstraintOfProviderLabel() {
        NSLayoutConstraint.activate([
            providerLabel.leadingAnchor.constraint(
                equalTo: self.iconImageView.trailingAnchor,
                constant: Design.iconImageViewTrailingMargin),
            providerLabel.topAnchor.constraint(
                equalTo: appNameLabel.bottomAnchor,
                constant: Design.providerLabelTopMargin)
        ])
    }
    
    private func setContstraintOfPurchaseButton() {
        NSLayoutConstraint.activate([
            purchaseButton.leadingAnchor.constraint(
                equalTo: self.iconImageView.trailingAnchor,
                constant: Design.iconImageViewTrailingMargin),
            purchaseButton.bottomAnchor.constraint(
                equalTo: self.iconImageView.bottomAnchor)
        ])
    }
    
    private func setConstraintOfShareButton() {
        NSLayoutConstraint.activate([
            shareButton.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: Design.trailingMargin * -1),
            shareButton.bottomAnchor.constraint(
                equalTo: self.iconImageView.bottomAnchor)
        ])
    }
}

extension AppDetailSummaryCollectionViewCell {
    
    private func fillIconImage(url: String?) {
        _ = self.iconImageView.setImage(
            with: url,
            defaultImage: Design.defaultIconImage)
    }
    
    private func fillAppNameLabel(name: String?) {
        self.appNameLabel.text = name
    }
    
    private func fillProviderLabel(provider: String?) {
        self.providerLabel.text = provider
    }
    
    private func fillPurcahseButton(price: String?) {
        self.purchaseButton.setTitle(price, for: .normal)
    }

}
