//
//  SavedAppDetailTableViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/19.
//

import Combine
import UIKit

final class SavedAppDetailTableViewCell: BaseTableViewCell {
    
    private let appDetailPreview: AppDetailPreview = {
        let view = AppDetailPreview(isFolderButtonHidden: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var supportedDeviceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
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
        label.textColor = Design.supportedDeviceLabelTextColor
        return label
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
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.countryNameLabelFont
        label.textColor = Design.countryNameLabelTextColor
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private var cancellableTasks: [CancellableTask?]? = [CancellableTask?]()
    private var cancellables = Set<AnyCancellable>()
    
    override func addSubviews() {
        contentView.addSubview(appDetailPreview)
        contentView.addSubview(supportedDeviceLabel)
        contentView.addSubview(supportedDeviceStackView)
        contentView.addSubview(countryStackView)
        configureUI()
    }
    
    private func configureUI() {
        self.backgroundColor = .clear
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
            supportedDeviceLabel.centerYAnchor.constraint(equalTo: supportedDeviceStackView.centerYAnchor),
            supportedDeviceLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Design.contentViewPadding),
            supportedDeviceStackView.topAnchor.constraint(
                equalTo: appDetailPreview.bottomAnchor),
            supportedDeviceStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Design.contentViewPadding),
            supportedDeviceStackView.heightAnchor.constraint(
                equalToConstant: Design.supportedDeviceStackViewHeight),
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
                constant: -Design.contentViewPadding),
            countryStackView.heightAnchor.constraint(
                equalToConstant: Design.countryStackViewHeight)
        ])
    }
    
    override func prepareForReuse() {
        cancellableTasks?.forEach { task in
            task?.cancelTask()
        }
        countryNameLabel.text = nil
    }
    
    func bind(_ viewModel: SavedAppDetailTableViewCellModel) {
        self.supportedDeviceLabel.text = viewModel.supportedDeviceText
        self.appStoreLabel.text = viewModel.appStoreText
        self.countryNameLabel.text = "\(viewModel.countryName) \(viewModel.countryFlag)"
        Task {
            self.cancellableTasks = try await self.appDetailPreview.bind(
                viewModel.appDetailprevieViewModel)
        }
        self.updateSupportedDeviceStackView(with: viewModel.supportedDeviceIconImages)
    }
    
    func bind(_ viewModel: AnyPublisher<SavedAppDetailTableViewCellModel, Never>) {
        viewModel
            .receive(on: RunLoop.main)
            .sink { [weak self] viewModel in
                self?.supportedDeviceLabel.text = viewModel.supportedDeviceText
                self?.appStoreLabel.text = viewModel.appStoreText
                self?.countryNameLabel.text = "\(viewModel.countryName) \(viewModel.countryFlag)"
                Task {
                    self?.cancellableTasks = try await self?.appDetailPreview.bind(
                        viewModel.appDetailprevieViewModel)
                }
                self?.updateSupportedDeviceStackView(with: viewModel.supportedDeviceIconImages)
            }.store(in: &cancellables)
    }
    
    private func updateSupportedDeviceStackView(with images: [UIImage?]) {
        guard var deviceIconImageViews = supportedDeviceStackView.arrangedSubviews as? [DeviceIconImageView] else {
            return
        }
        
        for image in images {
            let deviceIconImageView: DeviceIconImageView? = {
                if let imageView = deviceIconImageViews.first {
                    deviceIconImageViews.removeFirst()
                    return imageView
                } else {
                    let imageView = DeviceIconImageView(frame: .zero)
                    supportedDeviceStackView.addArrangedSubview(imageView)
                    return imageView
                }
            }()
            deviceIconImageView?.image = image
        }
        
        for deviceIconImageView in deviceIconImageViews {
            deviceIconImageView.removeFromSuperview()
        }
    }
    
}

private enum Design {
    
    static let contentViewPadding: CGFloat = 20
    static let supportedDeviceStackViewMarginBottom: CGFloat = 7
    
    static let supportedDeviceStackViewHeight: CGFloat = 30
    static let countryStackViewHeight: CGFloat = 13
    
    static let supportedDeviceLabelFont: UIFont = .preferredFont(forTextStyle: .subheadline)
    static let appStoreLabelFont: UIFont = .preferredFont(forTextStyle: .subheadline)
    static let countryNameLabelFont: UIFont = .preferredFont(forTextStyle: .subheadline)
    
    static let supportedDeviceLabelTextColor: UIColor = .gray
    static let appStoreLabelTextColor: UIColor = .gray
    static let countryNameLabelTextColor: UIColor = Colors.grayLavender.color
    
    static let selectedBackgroundColor: UIColor = Colors.lilac.color
    
}
