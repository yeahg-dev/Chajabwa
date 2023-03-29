//
//  TitleSupplementaryView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/05.
//

import UIKit

// MARK: - TitleSupplementaryView

final class TitleSupplementaryView: UICollectionReusableView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.titleLabelTextColor
        return label
    }()
    
    lazy var separatorLayer: CALayer = {
        let layer = CALayer()
        let origin = CGPoint(x: 0 ,y: 0)
        let size = CGSize(width: self.bounds.width, height: Design.separatorWidth)
        layer.frame = CGRect(origin: origin, size: size)
        layer.backgroundColor = Design.separatorColor
        layer.drawsAsynchronously = true
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(separatorLayer)
        configureSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func bind(title: String?) {
        titleLabel.text = title
    }
    
    private func configureSubview() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontForContentSizeCategory = true
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Design.paddingTop),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        titleLabel.font = .boldSystemFont(ofSize: Design.titleFontSize)
    }
    
}

// MARK: - Design

private enum Design {

    // padding
    static let paddingTop: CGFloat = 15
    
    // size
    static let separatorWidth: CGFloat = 0.5
    
    // color
    static let titleLabelTextColor: UIColor = .black
    static let separatorColor: CGColor = UIColor.systemGray3.cgColor
    
    // font
    static let titleFontSize: CGFloat = 22
    
}
