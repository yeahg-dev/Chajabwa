//
//  ReleaseNoteCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/02.
//

import UIKit

protocol ReleaseNoteCollectionViewCellDelegate: AnyObject {
    
    func foldingButtonDidTapped(_ : ReleaseNoteCollectionViewCell)
    
}

final class ReleaseNoteCollectionViewCell: BaseCollectionViewCell {
    
    private let versionLabel = UILabel()
    private let currentVersionReleaseDateLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let foldingButton = UIButton(type: .custom)
    
    private var isFolded: Bool = true
    
    weak var delegate: ReleaseNoteCollectionViewCellDelegate?
    
    private lazy var showFoldingButton: [NSLayoutConstraint] = {
        return [
            foldingButton.topAnchor.constraint(
                equalTo: descriptionTextView.bottomAnchor,
                constant: Design.desciptionTextViewMarginBottom),
            foldingButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Design.paddingTrailing),
            foldingButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Design.paddingBottom)
        ]
    }()
    
    private lazy var hideFoldingButton: NSLayoutConstraint = {
        descriptionTextView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -Design.desciptionTextViewMarginBottom)
    }()
  
    override func addSubviews() {
        contentView.addSubview(versionLabel)
        contentView.addSubview(currentVersionReleaseDateLabel)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(foldingButton)
    }
    
    override func configureSubviews() {
        configureVersionLabel()
        configureCurrentVersionReleaseDateLabel()
        configureDescrpitionTextView()
        configureFoldingButton()
    }
    
    override func setConstraints() {
        invalidateTranslateAutoResizingMasks(of: [
            versionLabel, currentVersionReleaseDateLabel, foldingButton, descriptionTextView, contentView])
        setContstraintsOfContentView()
        setConstraintsOfVersionLabel()
        setConstraintsOfcurrentVersionReleaseDateLabel()
        setConstraintsOfFoldingButton()
        setContstraintsOfDescriptionView()
    }
    
    func bind(model: AppDetailViewModel.Item) {
        if case let .releaseNote(releaseNote) = model {
            versionLabel.text = releaseNote.version
            currentVersionReleaseDateLabel.text = releaseNote.currentVersionReleaseDate
            descriptionTextView.text = releaseNote.description
            
            if releaseNote.isTrucated {
                descriptionTextView.textContainer.maximumNumberOfLines = Design.textContainerMaximumNumberOfLines
            } else {
                descriptionTextView.textContainer.maximumNumberOfLines = Design.textContainerMaximumNumberOfLines
            }
            
            guard let button = releaseNote.buttonTitle else {
                NSLayoutConstraint.deactivate(showFoldingButton)
                hideFoldingButton.isActive = true
                return
            }
            
            foldingButton.setTitle(button, for: .normal)
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
    
    private func configureVersionLabel() {
        versionLabel.font = Design.decriptionTextViewFont
        versionLabel.textColor = Design.versionTextColor
    }
    
    private func configureCurrentVersionReleaseDateLabel() {
        currentVersionReleaseDateLabel.font = Design.currentVersionReleaseDateFont
        currentVersionReleaseDateLabel.textColor = Design.currentVersionReleaseDateTextColor
        currentVersionReleaseDateLabel.textAlignment = .right
    }

    private func configureDescrpitionTextView() {
        descriptionTextView.textContainer.lineBreakMode = .byTruncatingTail
        descriptionTextView.textContainer.maximumNumberOfLines = Design.textContainerMaximumNumberOfLines
        descriptionTextView.textContainerInset = UIEdgeInsets(
            top: Design.textContainerInsetTop,
            left: Design.textContainerInsetLeft,
            bottom: Design.textContainerInsetBottom,
            right: Design.textContainerInsetRight)
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isEditable = false
        descriptionTextView.textColor = Design.descriptionTextColor
        descriptionTextView.font = Design.decriptionTextViewFont
    }
    
}

// MARK: - configure layout

extension ReleaseNoteCollectionViewCell {
    
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
    
    private func setConstraintsOfVersionLabel() {
        NSLayoutConstraint.activate([
            versionLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Design.paddingLeading),
            versionLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Design.paddingTop),
            versionLabel.bottomAnchor.constraint(
                equalTo: descriptionTextView.topAnchor,
                constant: -Design.descriptionTextViewMarginTop)
        ])
    }
    
    private func setConstraintsOfcurrentVersionReleaseDateLabel() {
        NSLayoutConstraint.activate([
            currentVersionReleaseDateLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Design.paddingTop),
            currentVersionReleaseDateLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Design.paddingTrailing),
            currentVersionReleaseDateLabel.bottomAnchor.constraint(
                equalTo: descriptionTextView.topAnchor,
                constant: -Design.descriptionTextViewMarginTop)
        ])
    }
    
    private func setContstraintsOfDescriptionView() {
        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Design.paddingLeading),
            descriptionTextView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Design.paddingTrailing),
            descriptionTextView.widthAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.width
                - Design.paddingLeading - Design.paddingTrailing)
        ])
    }
    
    private func setConstraintsOfFoldingButton() {
        NSLayoutConstraint.activate(showFoldingButton)
    }
    
}

// MARK: - Design

private enum Design {
    
    // padding
    static let paddingLeading = AppDetailCollectionViewCellDesign.paddingLeading
    static let paddingTop = AppDetailCollectionViewCellDesign.paddingTop
    static let paddingTrailing = AppDetailCollectionViewCellDesign.paddingTrailing
    static let paddingBottom = AppDetailCollectionViewCellDesign.paddingBottom
    
    // margin
    static let desciptionTextViewMarginBottom: CGFloat = 5
    static let descriptionTextViewMarginTop: CGFloat = 10
    
    // textContainer
    static let textContainerInsetTop: CGFloat = 0
    static let textContainerInsetLeft: CGFloat = -5
    static let textContainerInsetRight: CGFloat = -5
    static let textContainerInsetBottom: CGFloat = 0
    
    static let textContainerMaximumNumberOfLines: Int = 3
    static let textContainerMinimumNumberOfLines: Int = 0
    
    // size
    static let foldingButtonWidth: CGFloat = 100
    static let foldingButtonHeight: CGFloat = 25
    
    // font
    static let versionFont: UIFont = .preferredFont(forTextStyle: .callout)
    static let currentVersionReleaseDateFont: UIFont = .preferredFont(forTextStyle: .callout)
    static let foldingButtonFont: UIFont = .preferredFont(forTextStyle: .callout)
    static let decriptionTextViewFont: UIFont = .preferredFont(forTextStyle: .callout)
    
    // text color
    static let versionTextColor: UIColor = .systemGray
    static let currentVersionReleaseDateTextColor: UIColor = .systemGray
    static let foldingButtonTextColor: UIColor = .systemBlue
    static let descriptionTextColor: UIColor = .label
    
}
