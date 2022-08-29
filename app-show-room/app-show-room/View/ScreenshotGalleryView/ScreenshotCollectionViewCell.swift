//
//  ScreenShotCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

private enum Design {
    
    static let defaultImage = UIImage(withBackground: .systemGray4)
    static let cellCornerRadius: CGFloat = 9
}

final class ScreenShotCollectionViewCell: UICollectionViewCell {
    
    private let screenShotView = UIImageView()
    
    private var cancellableTask: CancellableTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(with imageURLString: String) {
        cancellableTask = self.screenShotView.setImage(
            with: imageURLString,
            defaultImage: Design.defaultImage)
    }
    
    override func prepareForReuse() {
        cancellableTask?.cancelTask()
        screenShotView.image = Design.defaultImage
    }
    
    private func configureSubview() {
        contentView.addSubview(screenShotView)
        setConstraintOfScreenShotView()
        configureUI()
    }
    
    private func setConstraintOfScreenShotView() {
        invalidateTranslateAutoResizingMasks(
            of: [screenShotView])
        NSLayoutConstraint.activate([
            screenShotView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),
            screenShotView.topAnchor.constraint(
                equalTo: contentView.topAnchor),
            screenShotView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            screenShotView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor),
            screenShotView.widthAnchor.constraint(equalToConstant: CGFloat(280)),
            screenShotView.heightAnchor.constraint(equalToConstant: CGFloat(500))
        ])
    }
    
    private func configureUI() {
        contentView.layer.cornerRadius = Design.cellCornerRadius
        contentView.clipsToBounds = true
    }
    
}
