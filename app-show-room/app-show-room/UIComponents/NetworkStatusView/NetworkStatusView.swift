//
//  NetworkStatusView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/03/27.
//

import UIKit

class NetworkStatusView: UIView {
    
    private let status: NetworkStatus
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .black
        label.text = status.description
        return label
    }()
    
    init(frame: CGRect, status: NetworkStatus) {
        self.status = status
        super.init(frame: frame)
        self.backgroundColor = Colors.grayLavender.color
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        self.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.widthAnchor.constraint(
                equalTo: self.widthAnchor),
            descriptionLabel.bottomAnchor.constraint(
                equalTo: self.bottomAnchor)
        ])
    }
    
}
