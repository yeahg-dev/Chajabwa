//
//  SummaryCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/03.
//

import UIKit

final class SummaryCollectionViewCell: BaseCollectionViewCell {
    
    var showsSeparator = true {
        didSet {
            updateSeparator()
        }
    }
    private let design = SummaryCollectionViewCellDesign.self
    
    private lazy var primaryTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = design.primaryTextLabelFont
        label.textColor = design.primaryTextColor
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var secondaryTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = design.primaryTextLabelFont
        label.textColor = design.primaryTextColor
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = design.preferredSymbolConfiguration
        imageView.tintColor = design.symbolImageTintColor
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            primaryTextLabel, symbolImageView, secondaryTextLabel,
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var separatorLayer: CALayer = {
        let layer = CALayer()
        let origin = CGPoint(x: self.bounds.width - design.separatorWidth, y: (self.bounds.height - design.separatorHeight) / 2)
        let size = CGSize(width: design.separatorWidth, height: design.separatorHeight)
        layer.frame = CGRect(origin: origin, size: size)
        layer.backgroundColor = design.separatorColor
        layer.drawsAsynchronously = true
        return layer
    }()
    
    override func addSubviews() {
        contentView.addSubview(stackView)
        self.layer.addSublayer(separatorLayer)
    }

    override func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.widthAnchor.constraint(equalToConstant: design.width),
            stackView.heightAnchor.constraint(equalToConstant: design.height)
        ])
    }
    
    override func prepareForReuse() {
        symbolImageView.image = nil
        showsSeparator = true
    }
    
    func bind(
        primaryText: String?,
        secondaryText: String?,
        symbolImage: UIImage?) {
            primaryTextLabel.text = primaryText
            secondaryTextLabel.text = secondaryText
            symbolImageView.image = symbolImage
        }
    
    private func updateSeparator() {
        separatorLayer.isHidden = !showsSeparator
    }
    
}
