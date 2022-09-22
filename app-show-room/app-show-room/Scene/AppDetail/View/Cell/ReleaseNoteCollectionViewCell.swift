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
    
    private let design = ReleaseNoteCollectionViewCellDesign.self
    
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
                constant: design.desciptionTextViewMarginBottom),
            foldingButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -design.paddingTrailing),
            foldingButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -design.paddingBottom)
        ]
    }()
    
    private lazy var hideFoldingButton: NSLayoutConstraint = {
        descriptionTextView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -design.desciptionTextViewMarginBottom)
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
                descriptionTextView.textContainer.maximumNumberOfLines = design.textContainerMaximumNumberOfLines
            } else {
                descriptionTextView.textContainer.maximumNumberOfLines = design.textContainerMaximumNumberOfLines
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
    
    private func configureVersionLabel() {
        versionLabel.font = design.decriptionTextViewFont
        versionLabel.textColor = design.versionTextColor
    }
    
    private func configureCurrentVersionReleaseDateLabel() {
        currentVersionReleaseDateLabel.font = design.currentVersionReleaseDateFont
        currentVersionReleaseDateLabel.textColor = design.currentVersionReleaseDateTextColor
        currentVersionReleaseDateLabel.textAlignment = .right
    }

    private func configureDescrpitionTextView() {
        descriptionTextView.textContainer.lineBreakMode = .byTruncatingTail
        descriptionTextView.textContainer.maximumNumberOfLines = design.textContainerMaximumNumberOfLines
        descriptionTextView.textContainerInset = UIEdgeInsets(
            top: design.textContainerInsetTop,
            left: design.textContainerInsetLeft,
            bottom: design.textContainerInsetBottom,
            right: design.textContainerInsetRight)
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isEditable = false
        descriptionTextView.textColor = design.descriptionTextColor
        descriptionTextView.font = design.decriptionTextViewFont
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
                constant: design.paddingLeading),
            versionLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: design.paddingTop),
            versionLabel.bottomAnchor.constraint(
                equalTo: descriptionTextView.topAnchor,
                constant: -design.descriptionTextViewMarginTop)
        ])
    }
    
    private func setConstraintsOfcurrentVersionReleaseDateLabel() {
        NSLayoutConstraint.activate([
            currentVersionReleaseDateLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: design.paddingTop),
            currentVersionReleaseDateLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -design.paddingTrailing),
            currentVersionReleaseDateLabel.bottomAnchor.constraint(
                equalTo: descriptionTextView.topAnchor,
                constant: -design.descriptionTextViewMarginTop)
        ])
    }
    
    private func setContstraintsOfDescriptionView() {
        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: design.paddingLeading),
            descriptionTextView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -design.paddingTrailing),
            descriptionTextView.widthAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.width
                - design.paddingLeading - design.paddingTrailing)
        ])
    }
    
    private func setConstraintsOfFoldingButton() {
        NSLayoutConstraint.activate(showFoldingButton)
    }
    
}
