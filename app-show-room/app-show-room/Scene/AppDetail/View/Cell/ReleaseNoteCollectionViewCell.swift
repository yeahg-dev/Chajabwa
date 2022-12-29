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
    
    weak var delegate: ReleaseNoteCollectionViewCellDelegate?
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [versionStackView, descriptionTextView, buttonView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 7
        return stackView
    }()
    
    private lazy var versionStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [versionLabel, currentVersionReleaseDateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.decriptionTextViewFont
        label.textColor = Design.versionTextColor
        label.textAlignment = .left
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let currentVersionReleaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.currentVersionReleaseDateFont
        label.textColor = Design.currentVersionReleaseDateTextColor
        label.textAlignment = .right
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainer.maximumNumberOfLines = Design.textContainerMaximumNumberOfLines
        textView.textContainerInset = UIEdgeInsets(
            top: Design.textContainerInsetTop,
            left: Design.textContainerInsetLeft,
            bottom: Design.textContainerInsetBottom,
            right: Design.textContainerInsetRight)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textColor = Design.descriptionTextColor
        textView.font = Design.decriptionTextViewFont
        return textView
    }()
    
    private lazy var buttonView: UIView = {
        let view = UIView(
            frame: CGRect(
                origin: .zero,
                size: .init(
                    width: contentView.frame.width,
                    height: foldingButton.intrinsicContentSize.height)))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(foldingButton)
        return view
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
        contentView.addSubview(containerStackView)
    }
    
    override func setConstraints() {
         NSLayoutConstraint.activate([
             contentView.topAnchor.constraint(equalTo: self.topAnchor),
             contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
             contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             containerStackView.leadingAnchor.constraint(
                 equalTo: contentView.leadingAnchor,
                 constant: Design.paddingLeading),
             containerStackView.trailingAnchor.constraint(
                 equalTo: contentView.trailingAnchor,
                 constant: -Design.paddingTrailing),
             containerStackView.topAnchor.constraint(
                 equalTo: contentView.topAnchor,
                 constant: Design.paddingTop),
             containerStackView.bottomAnchor.constraint(
                 equalTo: contentView.bottomAnchor,
                 constant: -Design.paddingBottom),
             foldingButton.topAnchor.constraint(
                 equalTo: buttonView.topAnchor),
             foldingButton.trailingAnchor.constraint(
                 equalTo: buttonView.trailingAnchor),
             foldingButton.bottomAnchor.constraint(
                 equalTo: buttonView.bottomAnchor)
         ])
    }
    
    func bind(model: AppDetailViewModel.Item) {
        if case let .releaseNote(releaseNote) = model {
            versionLabel.text = releaseNote.version
            currentVersionReleaseDateLabel.text = releaseNote.currentVersionReleaseDate
            descriptionTextView.text = releaseNote.description
          
            if releaseNote.isTrucated {
                descriptionTextView.textContainer.maximumNumberOfLines = Design.textContainerMinimumNumberOfLines
            } else {
                descriptionTextView.textContainer.maximumNumberOfLines = Design.textContainerMaximumNumberOfLines
            }
            
            if let description = releaseNote.description,
               description.count < 100 {
                foldingButton.isHidden = true
            } else {
                foldingButton.setTitle(releaseNote.buttonTitle, for: .normal)
            }
        }
    }
    
    @objc private func toggleFoldingButton() {
        delegate?.foldingButtonDidTapped(self)
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
    
    static let textContainerMaximumNumberOfLines: Int = 0
    static let textContainerMinimumNumberOfLines: Int = 3
    
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
