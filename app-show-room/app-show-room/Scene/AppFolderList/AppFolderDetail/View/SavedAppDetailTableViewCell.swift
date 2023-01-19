//
//  SavedAppDetailTableViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/19.
//

import UIKit

final class SavedAppDetailTableViewCell: BaseTableViewCell {
    
    private let appDetailPreview: AppDetailPreview = {
        let view = AppDetailPreview(isFolderButtonHidden: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var supportedDeviceStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [supportedDeviceLabel,
                               iphoneIconImageView,
                               ipadIconImageView,
                               macIconImageView,
                               appleWatchIconImageView])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let supportedDeviceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.supportedDeviceLabelFont
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let iconImageViews = [UIImageView]()
    
    private let iphoneIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let ipadIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let macIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let appleWatchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var countryStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [appStoreLabel, countryNameLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private let appStoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.appStoreLabelFont
        label.textColor = Design.appStoreLabelTextColor
        return label
    }()
    
    private let countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.countryNameLabelFont
        label.textColor = Design.countryNameLabelTextColor
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private var cancellableTasks = [CancellableTask?]()
    
    override func addSubviews() {
        contentView.addSubview(appDetailPreview)
        contentView.addSubview(supportedDeviceStackView)
        contentView.addSubview(countryStackView)
        configureUI()
    }
    
    private func configureUI() {
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = Design.selectedBackgroundColor
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            appDetailPreview.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),
            appDetailPreview.topAnchor.constraint(
                equalTo: contentView.topAnchor),
            appDetailPreview.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            supportedDeviceStackView.topAnchor.constraint(
                equalTo: appDetailPreview.bottomAnchor),
            supportedDeviceStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Design.contentViewPadding),
            supportedDeviceStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Design.contentViewPadding),
            countryStackView.topAnchor.constraint(
                equalTo: supportedDeviceStackView.bottomAnchor,
                constant: Design.supportedDeviceStackViewMarginBottom),
            countryStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Design.contentViewPadding),
            countryStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Design.contentViewPadding),
            countryStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Design.contentViewPadding)
        ])
    }
    
    override func prepareForReuse() {
        cancellableTasks.forEach { task in
            task?.cancelTask()
        }
        countryNameLabel.text = nil
        iconImageViews.forEach { imageView in
            imageView.image = nil
        }
    }
    
    func bind(_ viewModel: SavedAppDetailTableViewCellModel) {
        supportedDeviceLabel.text = viewModel.supportedDeviceText
        appStoreLabel.text = viewModel.appStoreText
        countryNameLabel.text = "\(viewModel.countryName) \(viewModel.countryFlag)"
        Task {
            cancellableTasks = try await appDetailPreview.bind(
                viewModel.appDetailprevieViewModel)
        }
        viewModel.supportedDeviceIconImages.enumerated().forEach { (index, image) in
            iconImageViews[index].image = image
        }
    }
    
}

private enum Design {
    
    static let contentViewPadding: CGFloat = 20
    static let supportedDeviceStackViewMarginBottom: CGFloat = 7
    
    static let supportedDeviceStackViewHeight: CGFloat = 30
    static let deviceImageViewWidth: CGFloat = 27
    static let deviceImageViewHeight: CGFloat = 27
    
    static let supportedDeviceLabelFont: UIFont = .preferredFont(forTextStyle: .subheadline)
    static let appStoreLabelFont: UIFont = .preferredFont(forTextStyle: .subheadline)
    static let countryNameLabelFont: UIFont = .preferredFont(forTextStyle: .subheadline)
    
    static let supportedDeviceLabelTextColor: UIColor = .black
    static let appStoreLabelTextColor: UIColor = .black
    static let countryNameLabelTextColor: UIColor = .black
    
    static let selectedBackgroundColor: UIColor = Color.lilac
    
}
