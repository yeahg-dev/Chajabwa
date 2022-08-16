//
//  AppDetailDescriptionTableViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

private enum Design {
    
    static let leadingMargin = CGFloat(25)
    static let topMargin = CGFloat(5)
    static let trailingMargin = CGFloat(25)
    static let bottomMargin = CGFloat(5)
    static let spacing = CGFloat(5)
}

final class AppDetailDescriptionTableViewCell: BaseAppDetailTableViewCell {
    
    override var height: CGFloat { UIScreen.main.bounds.height * 0.2 }
    
    private let descriptionTextView = UITextView()
    private let foldingButton = UIButton()
    
    private var isFolded: Bool = false {
        didSet {
            descriptionTextView.invalidateIntrinsicContentSize()
            self.layoutIfNeeded()
        }
    }
    
    override func configureSubviews() {
        self.addSubviews()
        self.setConstraintsSubviews()
    }

    override func bind(model: BaseAppDetailTableViewCellModel) {
        self.descriptionTextView.text = model.app.description
    }
    
    private func addSubviews() {
        self.contentView.addSubview(descriptionTextView)
        self.contentView.addSubview(foldingButton)
    }
    
    private func setConstraintsSubviews() {
        self.setConstraintsOfFoldingButton()
        self.setContstraintsOfDescriptionView()
    }
    
    private func configureFoldingButton() {
        self.setFoldedButton(isFolded: false)
        foldingButton.addTarget(
            self,
            action: #selector(toggleFoldingButton),
            for: .touchUpInside)
    }
    
    @objc private func toggleFoldingButton() {
        let isFolded = !foldingButton.isSelected
        if isFolded {
            self.setFoldedButton(isFolded: isFolded)
        } else {
            self.setFoldedButton(isFolded: isFolded)
        }
    }
    
    private func setFoldedButton(isFolded: Bool) {
        if isFolded {
            self.isFolded = false
            self.foldingButton.titleLabel?.text = "간략히"
            self.descriptionTextView.textContainer.maximumNumberOfLines = 0
        } else {
            self.isFolded = true
            self.foldingButton.titleLabel?.text = "더보기"
            self.descriptionTextView.textContainer.maximumNumberOfLines = 3
        }
    }
}

// MARK: - SetConstraints UIComponents

extension AppDetailDescriptionTableViewCell {
    
    private func setContstraintsOfDescriptionView() {
        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: Design.leadingMargin),
            descriptionTextView.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: Design.topMargin),
            descriptionTextView.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: Design.trailingMargin),
            descriptionTextView.bottomAnchor.constraint(
                equalTo: self.foldingButton.topAnchor,
                constant: Design.spacing)
        ])
    }
    
    private func setConstraintsOfFoldingButton() {
        NSLayoutConstraint.activate([
            foldingButton.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: Design.leadingMargin),
            foldingButton.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: Design.trailingMargin),
            foldingButton.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: Design.bottomMargin)
        ])
    }
    
}
