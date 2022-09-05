//
//  TitleSupplementaryView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/05.
//

import UIKit

final class TitleSupplementaryView: UICollectionReusableView {
    
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func bind(title: String?) {
        label.text = title
    }
    
}

extension TitleSupplementaryView {
    
    func configureSubview() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        label.font = .boldSystemFont(ofSize: 22)
    }
}
