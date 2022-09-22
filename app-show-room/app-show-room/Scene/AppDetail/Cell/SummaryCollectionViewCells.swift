////
////  SummaryCollectionViewCells.swift
////  app-show-room
////
////  Created by Moon Yeji on 2022/09/03.
////
//
//import UIKit
//
//final class SummaryCollectionViewCells: BaseCollectionViewCell {
//    
//    var showsSeparator = true {
//        didSet {
//            updateSeparator()
//        }
//    }
//
//    private let design = SummaryCollectionViewCellDesign.self
//    
//    private lazy var primaryTextLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = design.primaryTextLabelFont
//        label.textColor = design.primaryTextColor
//        label.numberOfLines = 1
//        return label
//    }()
//    
//    private lazy var secondaryTextLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = design.primaryTextLabelFont
//        label.textColor = design.primaryTextColor
//        label.numberOfLines = 1
//        return label
//    }()
//    
//    private lazy var symbolImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFit
//        imageView.preferredSymbolConfiguration = design.preferredSymbolConfiguration
//        imageView.tintColor = design.symbolImageTintColor
//        return imageView
//    }()
//    
//    private lazy var stackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [
//            primaryTextLabel, symbolImageView, secondaryTextLabel,
//        ])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.alignment = .center
//        stackView.distribution = .equalSpacing
//        return stackView
//    }()
//    
//    private lazy var separatorLayer: CALayer = {
//        let layer = CALayer()
//        let origin = CGPoint(x: self.bounds.width - design.separatorWidth, y: (self.bounds.height - design.separatorHeight) / 2)
//        let size = CGSize(width: design.separatorWidth, height: design.separatorHeight)
//        layer.frame = CGRect(origin: origin, size: size)
//        layer.backgroundColor = design.separatorColor
//        layer.drawsAsynchronously = true
//        return layer
//    }()
//    
//    override func addSubviews() {
//        contentView.addSubview(stackView)
//        self.layer.addSublayer(separatorLayer)
//        accessibilityIdentifier = "SummaryCollectionViewCell"
//    }
//
//    override func setConstraints() {
//        NSLayoutConstraint.activate([
//            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: design.paddingLeading),
//            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -design.paddingTrailing),
//            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
//    }
//    
//    override func prepareForReuse() {
//        symbolImageView.image = nil
//        showsSeparator = true
//    }
//    
//    func bind(model: AppDetailViewModel.Item) {
//        if case let .summary(summary) = model {
//            primaryTextLabel.text = summary.primaryText
//            secondaryTextLabel.text = summary.secnondaryText
//            symbolImageView.image = summary.symbolImage
//        }
//    }
//    
//    private func updateSeparator() {
//        separatorLayer.isHidden = !showsSeparator
//    }
//    
//}
