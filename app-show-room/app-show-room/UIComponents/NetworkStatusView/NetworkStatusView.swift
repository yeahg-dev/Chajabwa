//
//  NetworkStatusView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/03/27.
//

import UIKit

class NetworkStatusView: UIView {
    
    private var status: NetworkStatus
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .black
        label.text = status.description
        label.textAlignment = .center
        return label
    }()
    
    init(frame: CGRect, status: NetworkStatus) {
        self.status = status
        super.init(frame: frame)
        self.frame = .init(
            origin: .zero,
            size: .init(
                width: frame.size.width,
                height: frame.size.height * 0.1))
        self.backgroundColor = Colors.grayLavender.color
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchStatus(_ status: NetworkStatus) {
        self.status = status
        descriptionLabel.text = status.description
    }
    
    private func configureLayout() {
        self.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.widthAnchor.constraint(
                equalTo: self.widthAnchor),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(
                equalTo: self.bottomAnchor,
                constant: -5)
        ])
    }
    
}
