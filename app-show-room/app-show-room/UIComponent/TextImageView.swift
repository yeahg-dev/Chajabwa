//
//  TextImageView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/03.
//

import UIKit

private enum Design {
    
    static let font: UIFont = .boldSystemFont(ofSize: 30)
    static let color: UIColor = .systemGray3
}

final class TextImageView: UIView {
    
    private let text: String
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.text
        label.font = Design.font
        label.textColor = Design.color
        label.numberOfLines = 1
        // TODO: - lineBreakStrategy
        label.lineBreakStrategy = .pushOut
        return label
    }()
    
    init(_ text: String) {
        self.text = text
        super.init(frame: .zero)
        configureSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubview(){
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}
