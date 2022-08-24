//
//  AppDetailSummaryCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import UIKit

final class AppDetailSummaryCollectionViewCell: BaseAppDetailCollectionViewCell {

    private let design = AppDetailSummaryDesign.self
    
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
            iconImageView, appNameLabel, providerLabel, purchaseButton, shareButton, self.contentView
        ])
        self.setContratinsOfIconImageView()
        self.setConstraintsOfAppNameLabel()
        self.setConstraintOfProviderLabel()
        self.setContstraintOfPurchaseButton()
        self.setConstraintOfShareButton()
        NSLayoutConstraint.activate([
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        self.contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
    }

    override func bind(model: BaseAppDetailCollectionViewCellModel) {
        self.fillIconImage(url: model.iconImageURL)
        self.fillAppNameLabel(name: model.name)
        self.fillProviderLabel(provider: model.provider)
        self.fillPurcahseButton(price: model.price)
    }

    override func systemLayoutSizeFitting(
        _ targetSize: CGSize) -> CGSize {
            var targetSize = targetSize
            targetSize.height = CGFloat.greatestFiniteMagnitude
            let size = super.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )

            return size
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
    }
    
    private func designAppNameLabel() {
        self.appNameLabel.font = design.appNameLabelFont
        self.appNameLabel.lineBreakMode = .byTruncatingTail
        self.appNameLabel.numberOfLines = 2
    }
    
    private func designProviderLabel() {
        self.providerLabel.font = design.providerLabelFont
        self.providerLabel.textColor = .gray
        self.providerLabel.numberOfLines = 1
    }
    
    private func designPurchaseButton() {
        self.purchaseButton.backgroundColor = .systemBlue
        self.purchaseButton.layer.cornerRadius = 10
        self.purchaseButton.titleLabel?.textColor = .white
        self.purchaseButton.titleLabel?.font = design.purchaseButtonFont
    }
    
    private func designShareButton() {
        let shareImage = design.shareButtonImage
        self.shareButton.titleLabel?.textColor = .white
        self.shareButton.titleLabel?.textAlignment = .center
        self.shareButton.setImage(shareImage, for: .normal)
    }
    
}

// MARK: - Set Constraints for UIComponents

extension AppDetailSummaryCollectionViewCell {
 
    private func setContratinsOfIconImageView() {
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(
                equalToConstant: design.iconImageViewWidth),
            iconImageView.heightAnchor.constraint(
                equalToConstant: design.iconImageViewHeight),
            iconImageView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: design.leadingMargin),
            iconImageView.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: design.topMargin),
            iconImageView.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: design.bottomMargin * -1)
        ])
    }
    
    private func setConstraintsOfAppNameLabel() {
        NSLayoutConstraint.activate([
            appNameLabel.leadingAnchor.constraint(
                equalTo: self.iconImageView.trailingAnchor,
                constant: design.iconImageViewTrailingMargin),
            appNameLabel.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: design.topMargin),
            appNameLabel.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: design.trailingMargin * -1),
        ])
    }
    
    private func setConstraintOfProviderLabel() {
        NSLayoutConstraint.activate([
            providerLabel.leadingAnchor.constraint(
                equalTo: self.iconImageView.trailingAnchor,
                constant: design.iconImageViewTrailingMargin),
            providerLabel.topAnchor.constraint(
                equalTo: appNameLabel.bottomAnchor,
                constant: design.providerLabelTopMargin),
            providerLabel.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
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
                equalTo: self.iconImageView.trailingAnchor,
                constant: design.iconImageViewTrailingMargin),
            purchaseButton.bottomAnchor.constraint(
                equalTo: self.iconImageView.bottomAnchor)
        ])
    }
    
    private func setConstraintOfShareButton() {
        NSLayoutConstraint.activate([
            shareButton.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: design.trailingMargin * -1),
            shareButton.bottomAnchor.constraint(
                equalTo: self.iconImageView.bottomAnchor)
        ])
    }
}

extension AppDetailSummaryCollectionViewCell {
    
    private func fillIconImage(url: String?) {
        _ = self.iconImageView.setImage(
            with: url,
            defaultImage: design.defaultIconImage)
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
