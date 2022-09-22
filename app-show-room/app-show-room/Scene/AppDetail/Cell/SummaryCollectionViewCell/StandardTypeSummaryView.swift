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
        stackView.spacing = 3
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let primaryTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = .init(font: .preferredFont(forTextStyle: .title2), scale: .large)
        imageView.tintColor = .gray
        return imageView
    }()
    
    private let secondaryTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}
