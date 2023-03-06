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
    
    weak var delegate: DescriptionCollectionViewCellDelegate?
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainer.lineBreakMode = .byCharWrapping
        textView.textContainer.maximumNumberOfLines = Design.textContainerMinimumNumberOfLines
        textView.textContainerInset = UIEdgeInsets(
            top: Design.textContainerInsetTop,
            left: Design.textContainerInsetLeft,
            bottom: Design.textContainerInsetBottom,
            right:  Design.textContainerInsetRight)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = Design.decriptionTextViewFont
        textView.backgroundColor = .clear
        textView.textColor = Design.descriptionTextViewTextColor
        return textView
    }()
    
    private lazy var foldingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Design.foldingButtonTextColor, for: .normal)
        button.setTitleColor(Design.foldingButtonTextColor, for: .selected)
        button.titleLabel?.font = Design.foldingButtonFont
        button.titleLabel?.textAlignment = .right
        button.addTarget(
            self,
            action: #selector(toggleFoldingButton),
            for: .touchUpInside)
        return button
    }()
    
    override func addSubviews() {
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(foldingButton)
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
            if descritpion.isTrucated {
                descriptionTextView.textContainer.maximumNumberOfLines = Design.textContainerMinimumNumberOfLines
            } else {
                descriptionTextView.textContainer.maximumNumberOfLines = Design.textContainerMaximumNumberOfLines
            }
            
            guard let descriptionText = descritpion.text else {
                foldingButton.isHidden = true
                return
            }
            
            if descriptionText.count < 100 {
                foldingButton.isHidden = true
            } else {
                foldingButton.setTitle(descritpion.buttonTitle, for: .normal)
            }
        }
    }
  
    @objc private func toggleFoldingButton() {
        delegate?.foldingButtonDidTapped(self)
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
    static let foldingButtonTextColor: UIColor = Colors.blueGreen.color
    static let descriptionTextViewTextColor: UIColor = .black
    
}
