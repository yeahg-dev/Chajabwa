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

    func bind(image: UIImage?, category: String?) {
        self.image = image
        self.category = category
        setNeedsUpdateConfiguration()
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
    var tintColor: UIColor? = .systemBlue
    
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
                constant: 5),
            categoryLabel.leadingAnchor.constraint(
                equalTo: layoutMarginsGuide.leadingAnchor,
                constant: 7),
            categoryLabel.bottomAnchor.constraint(
                equalTo: layoutMarginsGuide.bottomAnchor,
                constant: -5),
            imageView.trailingAnchor.constraint(
                equalTo: layoutMarginsGuide.trailingAnchor,
                constant: -7),
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
        imageView.tintColor = configuration.tintColor
        categoryLabel.text = configuration.category
        categoryLabel.font = .preferredFont(forTextStyle: .callout)
        categoryLabel.textColor = .systemBlue
    }
    
}
