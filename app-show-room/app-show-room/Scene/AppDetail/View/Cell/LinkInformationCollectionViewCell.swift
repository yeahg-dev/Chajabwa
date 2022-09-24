//
//  LinkInformationCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/01.
//

import UIKit

final class LinkInformationCollectionViewCell: UICollectionViewCell {
    
    var image: UIImage?
    var category: String?

    func bind(model: AppDetailViewModel.Item) {
        if case let .information(information) = model {
            self.image = information.image
            self.category = information.category
            setNeedsUpdateConfiguration()
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var content = LinkInformationContentConfiguration().updated(for: state)
        content.image = image
        content.category = category
        contentConfiguration = content
    }
}

struct LinkInformationContentConfiguration: UIContentConfiguration, Hashable {
    
    var category: String?
    var image: UIImage?
    
    func makeContentView() -> UIView & UIContentView {
        return LinkInformationContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}

final class LinkInformationContentView: UIView, UIContentView {
    
    private let imageView = UIImageView()
    private let categoryLabel = UILabel()
    
    private var appliedConfiguration: LinkInformationContentConfiguration!
    
    init(configuration: LinkInformationContentConfiguration) {
        super.init(frame: .zero)
        setSubviews()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var configuration: UIContentConfiguration {
        get {
            return appliedConfiguration
        }
        set {
            guard let newConfig = newValue as? LinkInformationContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }

    private func setSubviews() {
        addSubview(imageView)
        addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(
                equalTo: layoutMarginsGuide.topAnchor,
                constant: Design.paddingTop),
            categoryLabel.leadingAnchor.constraint(
                equalTo: layoutMarginsGuide.leadingAnchor,
                constant: Design.paddingLeading),
            categoryLabel.bottomAnchor.constraint(
                equalTo: layoutMarginsGuide.bottomAnchor,
                constant: -Design.paddingBottom),
            imageView.trailingAnchor.constraint(
                equalTo: layoutMarginsGuide.trailingAnchor,
                constant: -Design.paddingTrailing),
            imageView.topAnchor.constraint(
                equalTo: categoryLabel.topAnchor),
            imageView.bottomAnchor.constraint(
                equalTo: categoryLabel.bottomAnchor)
        ])
        imageView.preferredSymbolConfiguration = .init(font: .preferredFont(forTextStyle: .callout), scale: .large)
        imageView.isHidden = true
    }
    
    private func apply(configuration: LinkInformationContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        
        imageView.isHidden = configuration.image == nil
        imageView.image = configuration.image
        imageView.tintColor = Design.tintColor
        
        categoryLabel.text = configuration.category
        categoryLabel.font = Design.categoryLabelFont
        categoryLabel.textColor = Design.categoryLabelTextColor
    }
    
}

// MARK: - Design

private enum Design {
    
    // padding
    static let paddingTop: CGFloat = 5
    static let paddingLeading: CGFloat = 7
    static let paddingTrailing: CGFloat = 7
    static let paddingBottom: CGFloat = 5
    
    // font
    static let categoryLabelFont: UIFont = .preferredFont(forTextStyle: .callout)
    
    // text color
    static let categoryLabelTextColor: UIColor = .systemBlue
    static let tintColor: UIColor = .systemBlue
    
}
