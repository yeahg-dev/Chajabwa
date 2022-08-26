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
        self.configureSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(with imageURLString: String) {
        self.cancellableTask = self.screenShotView.setImage(
            with: imageURLString,
            defaultImage: Design.defaultImage)
    }
    
    override func prepareForReuse() {
        self.cancellableTask?.cancelTask()
        self.screenShotView.image = Design.defaultImage
    }
    
    private func configureSubview() {
        self.contentView.addSubview(screenShotView)
        self.setContstraintOfContentView()
        self.setConstraintOfScreenShotView()
        self.designCell()
    }
    
    private func setContstraintOfContentView() {
        NSLayoutConstraint.activate([
            self.contentView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor),
            self.contentView.topAnchor.constraint(
                equalTo: self.topAnchor),
            self.contentView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor),
            self.contentView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor)
        ])
    }
    
    private func setConstraintOfScreenShotView() {
        invalidateTranslateAutoResizingMasks(
            of: [screenShotView, self.contentView])
        NSLayoutConstraint.activate([
            screenShotView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor),
            screenShotView.topAnchor.constraint(
                equalTo: self.contentView.topAnchor),
            screenShotView.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor),
            screenShotView.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    private func designCell() {
        self.contentView.layer.cornerRadius = Design.cellCornerRadius
        self.contentView.clipsToBounds = true
    }
    
}
