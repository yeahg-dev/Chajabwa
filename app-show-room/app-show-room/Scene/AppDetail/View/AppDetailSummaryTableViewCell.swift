//
//  AppDetailSummaryTableViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import UIKit

private enum Design {
    
    static let topMargin = CGFloat(0)
    static let bottomMargin = CGFloat(20)
    static let trailingMargin = CGFloat(25)
    static let iconImageViewLeadingMargin = CGFloat(25)
    static let iconImageViewTrailingMargin = CGFloat(10)
    static let providerLabelTopMargin = CGFloat(10)
    
    static let defaultIconImage = UIImage(withBackground: .systemGray4)
}

final class AppDetailSummaryTableViewCell: BaseAppDetailTableViewCell {
    
    override var height: CGFloat { UIScreen.main.bounds.height * 0.3 }
    
    // MARK: - UIComponents
    private let iconImageView = UIImageView()
    private let appNameLabel = UILabel()
    private let providerLabel = UILabel()
    private let priceLabel = UILabel()
    private let shareButton = UIButton()

    override func configureSubviews() {
        self.designComponents()
        self.addSubviews()
        self.setConstraintsSubviews()
    }

    override func bind(model: BaseAppDetailTableViewCellModel) {
        self.fillIconImage(url: model.iconImageURL)
        self.fillAppNameLabel(name: model.name)
        self.fillProviderLabel(provider: model.provider)
        self.fillPriceLabel(price: model.price)
    }
    
    private func designComponents() {
        self.designIconImageView()
        self.designAppNameLabel()
        self.designProviderLabel()
        self.designPriceLabel()
        self.designShareButton()
    }
    
    private func addSubviews() {
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(appNameLabel)
        self.contentView.addSubview(providerLabel)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(shareButton)
    }
    
    private func setConstraintsSubviews() {
        self.setContratinsOfIconImageView()
        self.setConstraintsOfAppNameLabel()
        self.setConstraintOfProviderLabel()
        self.setContstraintOfPriceLabel()
        self.setConstraintOfShareButton()
    }
    
}

// MARK: - Design UIComponents

extension AppDetailSummaryTableViewCell {
    
    private func designIconImageView() {
        self.iconImageView.layer.cornerRadius = 6
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(
            equalTo: iconImageView.heightAnchor,
            multiplier: 1)])
    }
    
    private func designAppNameLabel() {
        self.appNameLabel.font = .preferredFont(forTextStyle: .title1)
        self.appNameLabel.lineBreakMode = .byTruncatingTail
        self.appNameLabel.numberOfLines = 2
    }
    
    private func designProviderLabel() {
        self.providerLabel.font = .preferredFont(forTextStyle: .callout)
        self.providerLabel.lineBreakMode = .byTruncatingTail
        self.providerLabel.numberOfLines = 1
    }
    
    private func designPriceLabel() {
        self.priceLabel.font = .preferredFont(forTextStyle: .headline)
        self.priceLabel.backgroundColor = .blue
        self.priceLabel.layer.cornerRadius = 19
        self.priceLabel.invalidateIntrinsicContentSize()
        self.priceLabel.adjustsFontSizeToFitWidth = true
        NSLayoutConstraint.activate([
            self.priceLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func designShareButton() {
        let shareImage = UIImage(
            systemName: "square.and.arrow.up")?.withTintColor(.blue)
        self.shareButton.setImage(shareImage, for: .normal)
    }
    
}

// MARK: - Set Constraints for UIComponents

extension AppDetailSummaryTableViewCell {
 
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
    
    private func setContstraintOfPriceLabel() {
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(
                equalTo: self.iconImageView.trailingAnchor,
                constant: Design.iconImageViewTrailingMargin),
            priceLabel.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: Design.bottomMargin)
        ])
    }
    
    private func setConstraintOfShareButton() {
        NSLayoutConstraint.activate([
            shareButton.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: Design.trailingMargin * -1),
            shareButton.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: Design.bottomMargin)
        ])
    }
}

extension AppDetailSummaryTableViewCell {
    
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
    
    private func fillPriceLabel(price: String?) {
        self.priceLabel.text = price
    }

}
