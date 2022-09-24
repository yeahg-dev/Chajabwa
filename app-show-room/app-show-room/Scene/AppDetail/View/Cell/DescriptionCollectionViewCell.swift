//
//  DescriptionCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

protocol DescriptionCollectionViewCellDelegate: AnyObject {
    
    func foldingButtonDidTapped(_ : DescriptionCollectionViewCell)
    
}

final class DescriptionCollectionViewCell: BaseCollectionViewCell {
    
    private let descriptionTextView = UITextView()
    private let foldingButton = UIButton(type: .custom)
    
    weak var delegate: DescriptionCollectionViewCellDelegate?
    
    private var isFolded: Bool = true
    
    override func addSubviews() {
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(foldingButton)
    }
    
    override func configureSubviews() {
        configureDescrpitionTextView()
        configureFoldingButton()
    }
    
    override func setConstraints() {
        invalidateTranslateAutoResizingMasks(of: [
            foldingButton, descriptionTextView, contentView])
        setContstraintsOfContentView()
        setConstraintsOfFoldingButton()
        setContstraintsOfDescriptionView()
    }
    
    func bind(model: AppDetailViewModel.Item) {
        if case let .description(descritpion) = model {
            descriptionTextView.text = descritpion.text
            foldingButton.setTitle(descritpion.buttonTitle, for: .normal)
            if descritpion.isTrucated {
                descriptionTextView.textContainer.maximumNumberOfLines = Design.textContainerMinimumNumberOfLines
            } else {
                descriptionTextView.textContainer.maximumNumberOfLines = Design.textContainerMaximumNumberOfLines
            }
        }
    }
    
    private func configureFoldingButton() {
        foldingButton.setTitleColor(Design.foldingButtonTextColor, for: .normal)
        foldingButton.setTitleColor(Design.foldingButtonTextColor, for: .selected)
        foldingButton.titleLabel?.font = Design.foldingButtonFont
        foldingButton.titleLabel?.textAlignment = .right
        foldingButton.addTarget(
            self,
            action: #selector(toggleFoldingButton),
            for: .touchUpInside)
    }
    
    @objc private func toggleFoldingButton() {
        delegate?.foldingButtonDidTapped(self)
    }

    private func configureDescrpitionTextView() {
        descriptionTextView.textContainer.lineBreakMode = .byTruncatingTail
        descriptionTextView.textContainer.lineBreakMode = .byCharWrapping
        descriptionTextView.textContainer.maximumNumberOfLines = Design.textContainerMinimumNumberOfLines
        descriptionTextView.textContainerInset = UIEdgeInsets(
            top: Design.textContainerInsetTop,
            left: Design.textContainerInsetLeft,
            bottom: Design.textContainerInsetBottom,
            right:  Design.textContainerInsetRight)
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isEditable = false
        descriptionTextView.font = Design.decriptionTextViewFont
    }
    
}

// MARK: - configure layout

extension DescriptionCollectionViewCell {
    
    private func setContstraintsOfContentView() {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor),
            contentView.topAnchor.constraint(
                equalTo: self.topAnchor),
            contentView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor)])
    }
    
    private func setContstraintsOfDescriptionView() {
        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Design.paddingLeading),
            descriptionTextView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Design.paddingTop),
            descriptionTextView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Design.paddingTrailing),
            descriptionTextView.bottomAnchor.constraint(
                equalTo: foldingButton.topAnchor,
                constant: Design.descriptionTextViewMarginBottom ),
            descriptionTextView.widthAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.width
                - Design.paddingLeading - Design.paddingTrailing)
        ])
    }
    
    private func setConstraintsOfFoldingButton() {
        NSLayoutConstraint.activate([
            foldingButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Design.paddingTrailing),
            foldingButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Design.paddingBottom),
        ])
    }
    
}

// MARK: - Design

private enum Design {
    
    // padding, spacing
    static let paddingLeading = AppDetailCollectionViewCellDesign.paddingLeading
    static let paddingTop = AppDetailCollectionViewCellDesign.paddingTop
    static let paddingTrailing = AppDetailCollectionViewCellDesign.paddingTrailing
    static let paddingBottom = AppDetailCollectionViewCellDesign.paddingBottom
    
    static let descriptionTextViewMarginBottom: CGFloat = 5
    
    // size
    static let foldingButtonWidth: CGFloat = 100
    static let foldingButtonHeight: CGFloat = 25
    
    // textContainer
    static let textContainerInsetTop: CGFloat = 0
    static let textContainerInsetLeft: CGFloat = -5
    static let textContainerInsetBottom: CGFloat = 0
    static let textContainerInsetRight: CGFloat = -5
    
    // font
    static let foldingButtonFont: UIFont = .preferredFont(forTextStyle: .callout)
    static let decriptionTextViewFont: UIFont = .preferredFont(forTextStyle: .callout)
    
    // numberOfLines
    static let textContainerMaximumNumberOfLines = 0
    static let textContainerMinimumNumberOfLines = 3

    // textColor
    static let foldingButtonTextColor: UIColor = .systemBlue
    
}
