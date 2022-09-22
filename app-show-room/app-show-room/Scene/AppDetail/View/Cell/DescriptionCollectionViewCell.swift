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
    
    private let design = DescriptionCollectionViewCellDesign.self
    
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
                descriptionTextView.textContainer.maximumNumberOfLines = design.textContainerMinimumNumberOfLines
            } else {
                descriptionTextView.textContainer.maximumNumberOfLines = design.textContainerMaximumNumberOfLines
            }
        }
    }
    
    private func configureFoldingButton() {
        foldingButton.setTitleColor(design.foldingButtonTextColor, for: .normal)
        foldingButton.setTitleColor(design.foldingButtonTextColor, for: .selected)
        foldingButton.titleLabel?.font = design.foldingButtonFont
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
        descriptionTextView.textContainer.maximumNumberOfLines = design.textContainerMinimumNumberOfLines
        descriptionTextView.textContainerInset = UIEdgeInsets(
            top: design.textContainerInsetTop,
            left: design.textContainerInsetLeft,
            bottom: design.textContainerInsetBottom,
            right:  design.textContainerInsetRight)
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isEditable = false
        descriptionTextView.font = design.decriptionTextViewFont
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
                constant: design.paddingLeading),
            descriptionTextView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: design.paddingTop),
            descriptionTextView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -design.paddingTrailing),
            descriptionTextView.bottomAnchor.constraint(
                equalTo: foldingButton.topAnchor,
                constant: design.descriptionTextViewMarginBottom ),
            descriptionTextView.widthAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.width
                - design.paddingLeading - design.paddingTrailing)
        ])
    }
    
    private func setConstraintsOfFoldingButton() {
        NSLayoutConstraint.activate([
            foldingButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -design.paddingTrailing),
            foldingButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -design.paddingBottom),
        ])
    }
    
}
