//
//  AppFolderCreationButton.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/13.
//

import UIKit

final class AppFolderCreationButton: UIControl {

    private let plusImage = Images.Icon.plus.image
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = plusImage
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.titleFont
        label.textColor = Design.tintColor
        label.text = Texts.create_new_folder
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAction(_ action: UIAction) {
        addAction(action, for: .touchDown)
    }
    
    private func setConstraints() {
        addSubview(imageView)
        addSubview(label)
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: Design.height),
            imageView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: Design.contentInsetLeading),
            imageView.widthAnchor.constraint(equalToConstant: Design.plusImageWidth),
            imageView.heightAnchor.constraint(equalToConstant: Design.plusImageHeight),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Design.imagePadding),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func bind() {
        // updateConfiguration()
    }
    
}

private enum Design {
    
    static let height: CGFloat = contentInsetTop + plusImageHeight + contentInsetBottom
    static let plusImageWidth: CGFloat = 25
    static let plusImageHeight: CGFloat = 25
    
    static let titleFont: UIFont = .preferredFont(forTextStyle: .headline)
    
    static let tintColor: UIColor = Colors.tintedLilac.color
    
    static let contentInsetLeading: CGFloat = 35
    static let contentInsetBottom: CGFloat = 15
    static let contentInsetTop: CGFloat = 15
    
    static let imagePadding: CGFloat = 14
    
}
