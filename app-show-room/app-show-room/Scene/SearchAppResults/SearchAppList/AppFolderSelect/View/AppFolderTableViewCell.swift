//
//  AppFolderTableViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/13.
//

import UIKit

class AppFolderTableViewCell: BaseTableViewCell {
    
    private var cancellableTask: CancellableTask?
    
    private let layoutGuide: UILayoutGuide = UILayoutGuide()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Design.iconImageViewCornerRadius
        imageView.layer.borderWidth = Design.iconImageViewBorderWidth
        imageView.layer.borderColor = Design.icomImageViewBorderColor
        return imageView
    }()
    
    private let defaultIconImage = UIImage(
        named: "defaultAppIcon")!
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [folderNameLabel, savedAppCountLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = Design.labelStackViewSpacing
        return stackView
    }()
    
    private let folderNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.folderNameLabelFont
        label.textColor = Design.folderNameLabelFontColor
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()

    private let savedAppCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.savedAppCountLabelFont
        label.textColor = Design.savedAppCountLabelFontColor
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let checkmarkView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let checkmarkImage = UIImage(named: "checkmark")
        imageView.image = checkmarkImage
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func bind(_ viewModel: AppFolderTableViewCellModel) {
        print("🎨bind with iconURL: \(viewModel.iconImageURL)")
        folderNameLabel.text = viewModel.folderName
        savedAppCountLabel.text = viewModel.folderCount
        checkmarkView.isHidden = !viewModel.isBelongedToFolder
        Task {
            cancellableTask = try await iconImageView.setImage(
                with: viewModel.iconImageURL,
                defaultImage: defaultIconImage)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("✨prepareForReuse✨")
        savedAppCountLabel.text = nil
        savedAppCountLabel.text = nil
        iconImageView.image = defaultIconImage
        cancellableTask?.cancelTask()
        accessoryType = .none
    }
   
    override func addSubviews() {
        contentView.addLayoutGuide(layoutGuide)
        contentView.addSubview(iconImageView)
        contentView.addSubview(labelStackView)
        contentView.addSubview(checkmarkView)
        configureUI()
    }
    
    private func configureUI() {
        tintColor = Design.cellTintColor
        backgroundColor = Design.backgroundColor
        let selectedBackgroudView = UIView()
        selectedBackgroudView.backgroundColor = Design.selectedBackgroundColor
        selectedBackgroundView = selectedBackgroudView
    }
    
    override func setConstraints() {
        let layoutGuideHeight = layoutGuide.heightAnchor.constraint(
            equalToConstant: Design.layoutGuideHeight)
        layoutGuideHeight.priority = .defaultHigh
        NSLayoutConstraint.activate([
            layoutGuideHeight,
            layoutGuide.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Design.contentViewPaddingLeading),
            layoutGuide.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Design.contentViewPaddingTop),
            layoutGuide.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Design.contentViewPaddingTrailing),
            layoutGuide.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Design.contentViewPaddingBottom),
            iconImageView.widthAnchor.constraint(
                equalToConstant: Design.iconImageViewWidth),
            iconImageView.heightAnchor.constraint(
                equalToConstant: Design.iconImageViewWidth),
            iconImageView.leadingAnchor.constraint(
                equalTo: layoutGuide.leadingAnchor),
            iconImageView.centerYAnchor.constraint(
                equalTo: layoutGuide.centerYAnchor),
            labelStackView.centerYAnchor.constraint(
                equalTo: layoutGuide.centerYAnchor),
            labelStackView.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: Design.iconViewTrailingMargin),
            labelStackView.trailingAnchor.constraint(
                lessThanOrEqualTo: checkmarkView.leadingAnchor,
                constant: -Design.labelStackViewTrailingMargin),
            checkmarkView.widthAnchor.constraint(
                equalToConstant: Design.checkmarkViewWidth),
            checkmarkView.heightAnchor.constraint(
                equalTo: checkmarkView.widthAnchor),
            checkmarkView.trailingAnchor.constraint(
                equalTo: layoutGuide.trailingAnchor),
            checkmarkView.centerYAnchor.constraint(
                equalTo: layoutGuide.centerYAnchor)
        ])
    }
    
}

private enum Design {
    
    static let contentViewPaddingLeading: CGFloat = 20
    static let contentViewPaddingTop: CGFloat = 15
    static let contentViewPaddingTrailing: CGFloat = 20
    static let contentViewPaddingBottom: CGFloat = 15
    
    static let layoutGuideHeight: CGFloat = iconImageViewWidth
    
    static let iconViewTrailingMargin: CGFloat = 13
    static let iconViewTopMargin: CGFloat = 3
    static let iconViewBottomMargin: CGFloat = 4
    static let labelStackViewTrailingMargin: CGFloat = 7
    
    static let labelStackViewSpacing: CGFloat = 5
    
    static let iconImageViewWidth: CGFloat = 60
    static let checkmarkViewWidth: CGFloat = 19
    
    static let iconImageViewCornerRadius: CGFloat = 12
    static let icomImageViewBorderColor: CGColor = UIColor.systemGray4.cgColor
    static let iconImageViewBorderWidth: CGFloat = 0.5
    
    static let folderNameLabelFont: UIFont = .preferredFont(forTextStyle: .callout)
    static let savedAppCountLabelFont: UIFont = .preferredFont(forTextStyle: .callout)
    
    static let backgroundColor: UIColor = .clear
    static let folderNameLabelFontColor: UIColor = .black
    static let savedAppCountLabelFontColor: UIColor = Color.grayLavender
    static let cellTintColor: UIColor = .red
    static let defaultImageBackgroundColor: UIColor = Color.lightGray
    static let selectedBackgroundColor = Color.lilac
    
}
