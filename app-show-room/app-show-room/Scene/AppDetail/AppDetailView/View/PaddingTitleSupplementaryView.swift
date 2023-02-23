//
//  PaddingTitleSupplementaryView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/13.
//

import UIKit

// inset을 적용하지 못하는 Section을 위한 TitleSupplementaryView
// leading, trailing에 padding을 적용함으로써 inset을 적용한 것과 같은 효과를 줌

final class PaddingTitleSupplementaryView: UICollectionReusableView {
  
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.titleLabelTextColor
        return label
    }()
    
    lazy var separatorLayer: CALayer = {
        let layer = CALayer()
        let origin = CGPoint(x: Design.paddingLeading ,y: 0)
        let size = CGSize(width: self.bounds.width - (Design.paddingLeading + Design.paddingTrailing), height: Design.separatorWidth)
        layer.frame = CGRect(origin: origin, size: size)
        layer.backgroundColor = Design.separatorColor
        layer.drawsAsynchronously = true
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(separatorLayer)
        configureSubview()
        backgroundColor = Colors.lightSkyBlue.color
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
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Design.paddingLeading),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Design.paddingTrailing),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Design.paddingTop),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        titleLabel.font = .boldSystemFont(ofSize: Design.titleFontSize)
    }
}

// MARK: - Design

private enum Design {
    
    static let paddingLeading: CGFloat = 25
    static let paddingTop: CGFloat = 15
    static let paddingTrailing: CGFloat = 25
    
    static let separatorWidth: CGFloat = 0.5
    
    static let titleLabelTextColor: UIColor = .black
    static let separatorColor: CGColor = UIColor.systemGray3.cgColor
    
    static let titleFontSize: CGFloat = 22
   
}
