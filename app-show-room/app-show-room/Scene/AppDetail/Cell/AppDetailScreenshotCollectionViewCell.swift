//
//  AppDetailScreenshotCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

final class AppDetailScreenshotCollectionViewCell: BaseAppDetailCollectionViewCell {
    
    private var screenshotGalleryView: ScreenshotGalleryView!
    
    private var screenshotURLs: [String]?
    
    override func addSubviews() {
        screenshotGalleryView = ScreenshotGalleryView(
            viewModel: self,
            style: .embeddedInAppDetailScene)
        contentView.addSubview(screenshotGalleryView)
    }
    
    override func configureSubviews() {
        screenshotGalleryView.delegate = self
    }
    
    override func setConstraints() {
        invalidateTranslateAutoResizingMasks(
            of: [screenshotGalleryView, self.contentView])
        setConstraintOfContentView()
        setConstraintOfScreenshotGalleryView()
    }
    
    override func bind(model: AppDetailViewModel.Item) {
        if case let .screenshot(_) = model {
            screenshotGalleryView.update()
        }
    }

}

// MARK: - configure layout

extension AppDetailScreenshotCollectionViewCell {
    
    private func setConstraintOfContentView() {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor),
            contentView.topAnchor.constraint(
                equalTo: self.topAnchor),
            contentView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor)])
    }
    
    private func setConstraintOfScreenshotGalleryView() {
        NSLayoutConstraint.activate([
            screenshotGalleryView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),
            screenshotGalleryView.topAnchor.constraint(
                equalTo: contentView.topAnchor),
            screenshotGalleryView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            screenshotGalleryView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor)
        ])
    }

}

// MARK: - ScreenshotGalleryViewDataSource

extension AppDetailScreenshotCollectionViewCell: ScreenshotGalleryViewDataSource {
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return screenshotURLs?.count ?? .zero
    }
    
    func screenshotURLForCell(at indexPath: IndexPath) -> String? {
        return screenshotURLs?[indexPath.row]
    }
    
}

// MARK: - ScreenshotGalleryViewDelegate

extension AppDetailScreenshotCollectionViewCell: ScreenshotGalleryViewDelegate {
    
    func didTappedScreenshot(_ viewModel: ScreenshotGalleryViewDataSource) {
        appDetailTableViewCellDelegate?.screenshotDidTapped(viewModel)
    }

}
