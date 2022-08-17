//
//  AppDetailDescriptionCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

final class AppDetailDescriptionCollectionViewCell: BaseAppDetailCollectionViewCell {
    
    private let design = AppDetilDescriptionDesign.self
    
    private let descriptionTextView = UITextView()
    private let foldingButton = UIButton(type: .custom)
    
    private var isFolded: Bool = false {
        willSet {
            self.setFoldingButton(isFolded: newValue)
            descriptionTextView.invalidateIntrinsicContentSize()
            self.layoutIfNeeded()
            self.appDetailTableViewCellDelegate?.foldingButtonDidTapped()
        }
    }
    
    override func configureSubviews() {
        self.addSubviews()
        self.setConstraints()
        self.designDescrpitionTextView()
        self.configureFoldingButton()
    }
    
    override func addSubviews() {
        self.contentView.addSubview(descriptionTextView)
        self.contentView.addSubview(foldingButton)
    }
    
    override func setConstraints() {
        self.invalidateTranslateAutoResizingMasks(of: [
            foldingButton, descriptionTextView, self.contentView])
        self.setConstraintsOfFoldingButton()
        self.setContstraintsOfDescriptionView()
    }

    override func bind(model: BaseAppDetailCollectionViewCellModel) {
        self.descriptionTextView.text = model.app.description
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
    
    private func configureFoldingButton() {
        self.foldingButton.setTitle("더 보기", for: .normal)
        self.foldingButton.setTitleColor(.systemBlue, for: .normal)
        self.foldingButton.setTitleColor(.systemBlue, for: .selected)
        self.foldingButton.titleLabel?.font = design.foldingButtonFont
        self.foldingButton.titleLabel?.textAlignment = .right
        foldingButton.addTarget(
            self,
            action: #selector(toggleFoldingButton),
            for: .touchUpInside)
    }
    
    @objc private func toggleFoldingButton() {
        self.isFolded.toggle()
    }
    
    private func setFoldingButton(isFolded: Bool) {
        if isFolded {
            self.foldingButton.setTitle("간략히", for: .normal)
            self.descriptionTextView.textContainer.maximumNumberOfLines = 0
        } else {
            self.foldingButton.setTitle("더 보기", for: .normal)
            self.descriptionTextView.textContainer.maximumNumberOfLines = 3
        }
    }
    
    private func designDescrpitionTextView() {
        self.descriptionTextView.textContainer.lineBreakMode = .byTruncatingTail
        self.descriptionTextView.textContainer.maximumNumberOfLines = 3
        self.descriptionTextView.isScrollEnabled = false
        self.descriptionTextView.isEditable = false
        self.descriptionTextView.font = design.decriptionTextViewFont
    }
    
}

// MARK: - SetConstraints UIComponents

extension AppDetailDescriptionCollectionViewCell {
    
    private func setContstraintsOfDescriptionView() {
        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: design.leadingMargin),
            descriptionTextView.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: design.topMargin),
            descriptionTextView.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: design.trailingMargin * -1),
            descriptionTextView.bottomAnchor.constraint(
                equalTo: self.foldingButton.topAnchor,
                constant: design.spacing ),
            descriptionTextView.widthAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.width
                - design.leadingMargin - design.trailingMargin)
        ])
    }
    
    private func setConstraintsOfFoldingButton() {
        NSLayoutConstraint.activate([
            foldingButton.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: design.trailingMargin * -1),
            foldingButton.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: design.bottomMargin * -1),
        ])
    }
    
}
