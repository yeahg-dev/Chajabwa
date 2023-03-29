//
//  StandardTypeSummaryView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/20.
//

import UIKit

final class StandardTypeSummaryView: UIView {
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [primaryTextLabel, symbolImageView, secondaryTextLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Design.stackViewSpacing
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let primaryTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.primaryTextFont
        label.textColor = Design.primaryTextColor
        label.numberOfLines = 1
        return label
    }()
    
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = Design.symbolImageViewSymbolConfiguration
        imageView.tintColor = Design.symbolImageTintColor
        return imageView
    }()
    
    private let secondaryTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.secondaryTextFont
        label.textColor = Design.secondaryTextColor
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var seperator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = Design.seperatorColor
        layer.frame = CGRect(
            origin: CGPoint(x: bounds.width, y: (bounds.height - Design.seperatorHeight) / 2),
            size: CGSize(width: Design.seperatorWidth, height: Design.seperatorHeight))
        return layer
    }()
    
    var hasSeperator: Bool = true {
        willSet {
            seperator.isHidden = !newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(seperator)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(primaryText: String?, symbolImage: UIImage?, secondaryText: String?) {
        primaryTextLabel.text = primaryText
        symbolImageView.image = symbolImage
        secondaryTextLabel.text = secondaryText
    }
    
    private func configureConstraints() {
        addSubview(containerStackView)
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 3),
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -3),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}

// MARK: - Design

private enum Design {
    
    // spacing
    static let stackViewSpacing: CGFloat = 3
    
    // color
    static let primaryTextColor: UIColor = .gray
    static let symbolImageTintColor: UIColor = .gray
    static let secondaryTextColor: UIColor = .gray
    static let seperatorColor: CGColor = UIColor.systemGray3.cgColor
    
    // font
    static let primaryTextFont: UIFont = .preferredFont(forTextStyle: .caption1)
    static let secondaryTextFont: UIFont = .preferredFont(forTextStyle: .caption1)
    static let symbolImageViewSymbolConfiguration = UIImage.SymbolConfiguration.init(font: .preferredFont(forTextStyle: .title2), scale: .large)
    
    // size
    static let seperatorWidth: CGFloat = 0.3
    static let seperatorHeight: CGFloat = 40
    
}
