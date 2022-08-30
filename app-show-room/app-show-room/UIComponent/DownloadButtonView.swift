//
//  DownloadButtonView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/30.
//

import UIKit

private enum Design {
    
    static let width: CGFloat = 70
    static let height: CGFloat = 27
    static let cornerRadius: CGFloat = 13
    static let font: UIFont = .preferredFont(forTextStyle: .subheadline)
    static let textColor: UIColor = .white
    static let backgroundColor: UIColor = .systemBlue
}

final class DownloadButtonView: UIView {
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: Design.width, height: Design.height)
    }
    
    private func configureView() {
        self.layer.cornerRadius = Design.cornerRadius
        self.clipsToBounds = true
    }
    
    private func configureLabel() {
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        titleLabel.backgroundColor = Design.backgroundColor
        titleLabel.textColor = Design.textColor
        titleLabel.text = "받기"
        titleLabel.textAlignment = .center
        titleLabel.font = Design.font
    }
    
}
