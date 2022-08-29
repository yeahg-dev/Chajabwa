//
//  AppDetailDescriptionCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

final class AppDetailDescriptionCollectionViewCell: BaseCollectionViewCell {
    
    private let design = AppDetilDescriptionDesign.self
    
    private let descriptionTextView = UITextView()
    private let foldingButton = UIButton(type: .custom)
    
    private var isFolded: Bool = false {
        willSet {
            setFoldingButton(isFolded: newValue)
            descriptionTextView.invalidateIntrinsicContentSize()
            appDetailTableViewCellDelegate?.foldingButtonDidTapped()
        }
    }
    
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
        }
    }
    
    private func configureFoldingButton() {
        foldingButton.setTitle("더 보기", for: .normal)
        foldingButton.setTitleColor(.systemBlue, for: .normal)
        foldingButton.setTitleColor(.systemBlue, for: .selected)
        foldingButton.titleLabel?.font = design.foldingButtonFont
        foldingButton.titleLabel?.textAlignment = .right
        foldingButton.addTarget(
            self,
            action: #selector(toggleFoldingButton),
            for: .touchUpInside)
    }
    
    @objc private func toggleFoldingButton() {
        isFolded.toggle()
    }
    
    private func setFoldingButton(isFolded: Bool) {
        if isFolded {
            foldingButton.setTitle("간략히", for: .normal)
            descriptionTextView.textContainer.maximumNumberOfLines = 0
        } else {
            foldingButton.setTitle("더 보기", for: .normal)
            descriptionTextView.textContainer.maximumNumberOfLines = 3
        }
    }
    
    private func configureDescrpitionTextView() {
        descriptionTextView.textContainer.lineBreakMode = .byTruncatingTail
        descriptionTextView.textContainer.maximumNumberOfLines = 3
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isEditable = false
        descriptionTextView.font = design.decriptionTextViewFont
    }
    
}

// MARK: - configure layout

extension AppDetailDescriptionCollectionViewCell {
    
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
                constant: design.leadingMargin),
            descriptionTextView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: design.topMargin),
            descriptionTextView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: design.trailingMargin * -1),
            descriptionTextView.bottomAnchor.constraint(
                equalTo: foldingButton.topAnchor,
                constant: design.spacing ),
            descriptionTextView.widthAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.width
                - design.leadingMargin - design.trailingMargin)
        ])
    }
    
    private func setConstraintsOfFoldingButton() {
        NSLayoutConstraint.activate([
            foldingButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: design.trailingMargin * -1),
            foldingButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: design.bottomMargin * -1),
        ])
    }
    
}
