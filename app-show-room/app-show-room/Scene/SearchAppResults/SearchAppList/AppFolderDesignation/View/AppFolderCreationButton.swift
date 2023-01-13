//
//  AppFolderCreationButton.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/13.
//

import UIKit

class AppFolderCreationButton: UIButton {

    private let plusImage = UIImage(named: "plus")
    
    private lazy var buttonConfiguratioin: UIButton.Configuration = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(
            top: Design.contentInset,
            leading: Design.contentInset,
            bottom: Design.contentInset,
            trailing: Design.contentInset)
        config.imagePadding = Design.imagePadding
        config.image = plusImage
        return config
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = Design.tintColor
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = Design.titleFont
        guard let imageView else {
            print("imageView 없음")
            return
            
        }
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(
                equalToConstant: Design.plusImageWidth),
            imageView.heightAnchor.constraint(
                equalToConstant: Design.plusImageHeight)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        // updateConfiguration()
    }
    
}

private enum Design {
    
    static let plusImageWidth: CGFloat = 30
    static let plusImageHeight: CGFloat = 30
    
    static let titleFont: UIFont = .preferredFont(forTextStyle: .headline)
    
    static let tintColor: UIColor = Color.lilac
    
    static let contentInset: CGFloat = 15
    static let imagePadding: CGFloat = 10
    
}
