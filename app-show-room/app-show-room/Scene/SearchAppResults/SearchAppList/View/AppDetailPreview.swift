//
//  AppDetailPreview.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/19.
//

import UIKit

class AppDetailPreview: UIView {
    
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
        label.font = Design.providerLabelFont
        label.textColor = Design.providerLabelTextColor
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
    
    convenience init(isFolderButtonHidden: Bool) {
        self.init(frame: frame)
        folderButton.isHidden = isFolderButtonHidden
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        containerView.addSubview(iconImageView)
        containerView.addSubview(labelsStackView)
        containerView.addSubview(folderButton)
        containerView.addSubview(screenshotStackView)
        self.addSubview(containerView)
    }
    
    private func configureUI() {
        backgroundColor = Design.backgroundColor
    }
    
    private func setConstraints() {
        let screenshotImageViewHeight = screenshotImageView1.height
        let screenshotStackViewHeightAnchor = screenshotStackView.heightAnchor.constraint(
            equalToConstant: screenshotImageViewHeight)
        screenshotStackViewHeightAnchor.priority = .defaultHigh
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: Design.contentViewPadding),
            containerView.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: Design.contentViewPadding),
            containerView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -Design.contentViewPadding),
            containerView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor,
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
    
    func bind(_ viewModel: AppDetailPreviewViewModel) async throws -> [CancellableTask?] {
        let defaultImage = UIImage(withBackground: .gray)
        nameLabel.text = viewModel.name
        providerLabel.text = viewModel.provider
        userRatingCountLabel.text = viewModel.userRatingCount
        if let rating = viewModel.averageUserRating {
            averageStarRatingView.update(rating: rating)
        }
        async let iconImageViewTask = iconImageView.setImage(
            with: viewModel.iconImageURL,
            defaultImage: defaultImage)
        async let screenshotImageView1Task = screenshotImageView1.setImage(
            with: viewModel.screenshotURLs?[safe: 0],
            defaultImage: defaultImage)
        async let screenshotImageView2Task = screenshotImageView2.setImage(
            with: viewModel.screenshotURLs?[safe: 1],
            defaultImage: defaultImage)
        async let screenshotImageView3Task = screenshotImageView3.setImage(
            with: viewModel.screenshotURLs?[safe: 2],
            defaultImage: defaultImage)
        return try await [iconImageViewTask, screenshotImageView1Task, screenshotImageView2Task, screenshotImageView3Task]
    }
    
}

private enum Design {
    
    // backgroundColor
    static let backgroundColor: UIColor = .clear
    
    // layer
    static let iconImageViewCornerRadius: CGFloat = 20
    static let icomImageViewBorderColor: CGColor = UIColor.systemGray4.cgColor
    static let iconImageViewBorderWidth: CGFloat = 0.5
    static let purchaseButtonCornerRadius: CGFloat = 13
    
    // font
    static let titleLabelFont: UIFont = .preferredFont(forTextStyle: .title3)
    static let providerLabelFont: UIFont = .preferredFont(forTextStyle: .subheadline)
    static let starRatingLabelFont: UIFont = .preferredFont(forTextStyle: .subheadline)
    
    // textColor
    static let nameLabelTextColor: UIColor = .black
    static let providerLabelTextColor: UIColor = .gray
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
