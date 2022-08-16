//
//  ScreenshotCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

enum Design {
    
    static let defaultImage = UIImage(withBackground: .systemGray4)
}

final class ScreenshotCollectionViewCell: UICollectionViewCell {
    
    private let screenshotView = UIImageView()
    
    private var cancellableTask: CancellableTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(with imageURLString: String) {
        self.cancellableTask = self.screenshotView.setImage(
            with: imageURLString,
            defaultImage: Design.defaultImage)
    }
    
    override func prepareForReuse() {
        self.cancellableTask?.cancelTask()
        self.screenshotView.image = Design.defaultImage
    }
    
    private func configureSubview() {
        self.contentView.addSubview(screenshotView)
        self.setConstraintOfScreenshotView()
        self.designCell()
    }
    
    private func setConstraintOfScreenshotView() {
        NSLayoutConstraint.activate([
            screenshotView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor),
            screenshotView.topAnchor.constraint(
                equalTo: self.contentView.topAnchor),
            screenshotView.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor),
            screenshotView.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    private func designCell() {
        self.contentView.layer.cornerRadius = 5
    }
    
}
