//
//  IconView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/30.
//

import UIKit

private enum Design {
    
    static let width: CGFloat = 25
    static let cornerRadius: CGFloat = 6
}

final class IconView: UIView {
    
    private let imageView = UIImageView()
    
    private var task: CancellableTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubview()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubview() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Design.cornerRadius
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Design.width),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
    func setImage(withURL url: String?) {
        let defaultImage = UIImage(withBackground: .systemGray5)
        Task {
            task = try await imageView.setImage(
                with: url,
                defaultImage: defaultImage)
        }
    }
    
    deinit {
        task?.cancelTask()
    }
    
}
