//
//  SearchAppTableViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/08.
//

import UIKit

protocol appFolderSelectViewPresnter: AnyObject {
    
    func pushAppFolderSelectView(of appUnit: AppUnit, iconImageURL: String?)
    
}

final class SearchAppTableViewCell: BaseTableViewCell {
    
    weak var appFolderSelectViewPresenter: appFolderSelectViewPresnter?
    
    private var appUnit: AppUnit?
    private var iconImageURL: String?
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [nameLabel, providerLabel, ratingStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = Design.labelStackViewSpacing
        return stackView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Design.iconImageViewCornerRadius
        imageView.layer.borderWidth = Design.iconImageViewBorderWidth
        imageView.layer.borderColor = Design.icomImageViewBorderColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.titleLabelFont
        label.textColor = Design.nameLabelTextColor
        return label
    }()
    
    private let providerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.descriptionLabelFont
        label.textColor = Design.descriptionLabelTextColor
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [averageStarRatingView, userRatingCountLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Design.ratingStackViewSpacing
        return stackView
    }()
    
    private let averageStarRatingView: StarRatingView = {
        let configuration = StarRatingViewConfiguration(
            starSize: Design.starSize,
            starMargin: Design.starMargin,
            tintColor: Design.starColor)
        let starRatingView = StarRatingView(
            rating: 0.0,
            configuration: configuration)
        return starRatingView
    }()
    
    private let userRatingCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.starRatingLabelFont
        label.textColor = Design.starRatingLabelTextColor
        label.textAlignment = .left
        return label
    }()
    
    private lazy var folderButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(
            UIImage(named: "addFolder"),
            for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(pushAppFolderSelectView), for: .touchUpInside)
        return button
    }()
    
    private lazy var screenshotStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [screenshotImageView1, screenshotImageView2, screenshotImageView3])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let screenshotImageView1 = ScreenshotImageView(frame: .zero)
    private let screenshotImageView2 = ScreenshotImageView(frame: .zero)
    private let screenshotImageView3 = ScreenshotImageView(frame: .zero)
    
    private var cancellableTasks: [CancellableTask] = []
    
    func bind(_ viewModel: SearchAppTableViewCellModel) {
        assignAppUnit(viewModel: viewModel)
        let defaultImage = UIImage(withBackground: .gray)
        Task {
            async let iconImageViewTask = iconImageView.setImage(
                with: viewModel.iconImageURL,
                defaultImage: defaultImage)
            async let screenshotImageView1Task = screenshotImageView1.setImage(
                with: viewModel.screenshotImageURLs?[safe: 0],
                defaultImage: defaultImage)
            async let screenshotImageView2Task = screenshotImageView2.setImage(
                with: viewModel.screenshotImageURLs?[safe: 1],
                defaultImage: defaultImage)
            async let screenshotImageView3Task = screenshotImageView3.setImage(
                with: viewModel.screenshotImageURLs?[safe: 2],
                defaultImage: defaultImage)
            if let iconImageViewTask = try? await iconImageViewTask,
               let screenshotImageView1Task = try? await screenshotImageView1Task,
               let screenshotImageView2Task = try? await screenshotImageView2Task,
               let screenshotImageView3Task = try? await screenshotImageView3Task
            {
                cancellableTasks.append(
                    contentsOf: [iconImageViewTask, screenshotImageView1Task,
                                 screenshotImageView2Task, screenshotImageView3Task])
            }
        }
        nameLabel.text = viewModel.name
        providerLabel.text = viewModel.provider
        userRatingCountLabel.text = viewModel.userRatingCount
        if let rating = viewModel.averageUserRating {
            averageStarRatingView.update(rating: rating)
        }
    }
    
    override func prepareForReuse() {
        cancellableTasks.forEach { task in
            task.cancelTask()
        }
    }
    
    override func addSubviews() {
        containerView.addSubview(iconImageView)
        containerView.addSubview(labelsStackView)
        containerView.addSubview(folderButton)
        containerView.addSubview(screenshotStackView)
        contentView.addSubview(containerView)
        configureUI()
    }
    
    private func configureUI() {
        backgroundColor = Design.backgroundColor
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = Design.selectedBackgroundColor
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    override func setConstraints() {
        let screenshotImageViewHeight = screenshotImageView1.height
        let screenshotStackViewHeightAnchor = screenshotStackView.heightAnchor.constraint(
            equalToConstant: screenshotImageViewHeight)
        screenshotStackViewHeightAnchor.priority = .defaultHigh
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Design.contentViewPadding),
            containerView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Design.contentViewPadding),
            containerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Design.contentViewPadding),
            containerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Design.contentViewPadding),
            containerView.leadingAnchor.constraint(
                equalTo: iconImageView.leadingAnchor),
            containerView.topAnchor.constraint(
                equalTo: iconImageView.topAnchor),
            iconImageView.widthAnchor.constraint(
                equalToConstant: Design.iconImageViewHeight),
            iconImageView.heightAnchor.constraint(
                equalToConstant: Design.iconImageViewHeight),
            labelsStackView.topAnchor.constraint(
                equalTo: iconImageView.topAnchor),
            labelsStackView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor),
            iconImageView.trailingAnchor.constraint(
                equalTo: labelsStackView.leadingAnchor,
                constant: -Design.iconImageViewTrailingMargin),
            folderButton.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor),
            folderButton.bottomAnchor.constraint(
                equalTo: iconImageView.bottomAnchor),
            folderButton.widthAnchor.constraint(
                equalToConstant: Design.folderButtonSize.width),
            folderButton.heightAnchor.constraint(
                equalToConstant: Design.folderButtonSize.height),
            screenshotStackViewHeightAnchor,
            screenshotStackView.topAnchor.constraint(
                equalTo: iconImageView.bottomAnchor,
                constant: Design.screenshotStackViewTopMargin),
            screenshotStackView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor),
            screenshotStackView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor),
            screenshotStackView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func assignAppUnit(viewModel: SearchAppTableViewCellModel) {
        iconImageURL = viewModel.iconImageURL
        let currentCountry = AppSearchingConfiguration.countryISOCode
        let currentPlatform = AppSearchingConfiguration.softwareType
        appUnit = AppUnit(
            name: viewModel.name!,
            appID: viewModel.appID!,
            country: currentCountry,
            platform: currentPlatform)
    }
    
    @objc
    private func pushAppFolderSelectView() {
        guard let appUnit else {
            return
        }
        appFolderSelectViewPresenter?.pushAppFolderSelectView(
            of: appUnit,
            iconImageURL: iconImageURL)
    }
    
}

extension SearchAppTableViewCell {
    
    // MARK: - Desigin
    
    private enum Design {
        
        // backgroundColor
        static let backgroundColor: UIColor = .clear
        static let selectedBackgroundColor: UIColor = Color.skyBlue
        
        // layer
        static let iconImageViewCornerRadius: CGFloat = 20
        static let icomImageViewBorderColor: CGColor = UIColor.systemGray4.cgColor
        static let iconImageViewBorderWidth: CGFloat = 0.5
        static let purchaseButtonCornerRadius: CGFloat = 13
        
        // font
        static let titleLabelFont: UIFont = .preferredFont(forTextStyle: .title3)
        static let descriptionLabelFont: UIFont = .preferredFont(forTextStyle: .subheadline)
        static let starRatingLabelFont: UIFont = .preferredFont(forTextStyle: .subheadline)
        
        // textColor
        static let nameLabelTextColor: UIColor = .black
        static let descriptionLabelTextColor: UIColor = .gray
        static let starRatingLabelTextColor: UIColor = .systemGray3
        
        // starRatingView
        static let starSize: CGFloat = 13
        static let starMargin: CGFloat = 3
        static let starColor: UIColor = .gray
        
        // size
        static let folderButtonSize: CGSize = .init(width: 30, height: 30)
        static let iconImageViewHeight: CGFloat = UIScreen.main.bounds.height * 0.1
        
        // padding, margin
        static let contentViewPadding: CGFloat = 20
        static let iconImageViewTrailingMargin: CGFloat = 10
        static let screenshotStackViewTopMargin: CGFloat = 15
        
        // spacing
        static let labelStackViewSpacing: CGFloat = 5
        static let ratingStackViewSpacing: CGFloat = 10
        static let defaultSpacing: CGFloat = 23
        
    }
    
}
