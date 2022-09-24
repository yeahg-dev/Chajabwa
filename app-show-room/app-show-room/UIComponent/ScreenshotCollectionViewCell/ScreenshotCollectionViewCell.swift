//
//  ScreenShotCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

class ScreenShotCollectionViewCell: BaseCollectionViewCell {
    
    private let screenShotView = UIImageView()
    
    private var cancellableTask: CancellableTask?
    
    var design: ScreenshotCollectionViewCellDesign.Type {
        return ScreenShotCollectionViewCellStyle.Normal.self
    }

    override func addSubviews() {
        contentView.addSubview(screenShotView)
    }
    
    override func configureSubviews() {
        configureUI()
    }

    override func setConstraints() {
        setConstraintOfScreenShotView()
    }
    
    override func prepareForReuse() {
        cancellableTask?.cancelTask()
        screenShotView.image = design.defaultImage
    }
    
    func fill(with imageURLString: String) {
        cancellableTask = self.screenShotView.setImage(
            with: imageURLString,
            defaultImage: design.defaultImage)
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
            screenShotView.widthAnchor.constraint(equalToConstant: design.width),
            screenShotView.heightAnchor.constraint(equalToConstant: design.height)
        ])
    }
    
    private func configureUI() {
        contentView.layer.cornerRadius = design.cornerRadius
        contentView.layer.borderColor = design.borderColor
        contentView.layer.borderWidth = design.borderWidth
        contentView.clipsToBounds = true
    }
    
}
