//
//  AppDetailScreenshotCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

final class AppDetailScreenshotCollectionViewCell: BaseAppDetailCollectionViewCell {
    
    private var screenshotGalleryView: ScreenshotGalleryView!
    
    private var appDetail: AppDetail?
    
    override func addSubviews() {
        self.screenshotGalleryView = ScreenshotGalleryView(
            viewModel: self,
            style: .embeddedInAppDetailScene)
        self.contentView.addSubview(screenshotGalleryView)
    }
    
    override func configureSubviews() {
        self.addSubviews()
        self.setConstraints()
        self.screenshotGalleryView.delegate = self
    }
    
    override func setConstraints() {
        self.invalidateTranslateAutoResizingMasks(of: [screenshotGalleryView, self.contentView])
        self.setConstraintOfContentView()
        self.setConstraintOfScreenshotGalleryView()
    }
    
    override func bind(model: BaseAppDetailCollectionViewCellModel) {
        self.appDetail = model.app
    }

}

extension AppDetailScreenshotCollectionViewCell {
    
    private func setConstraintOfContentView() {
        NSLayoutConstraint.activate([
            self.contentView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor),
            self.contentView.topAnchor.constraint(
                equalTo: self.topAnchor),
            self.contentView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor),
            self.contentView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor)])
    }
    
    private func setConstraintOfScreenshotGalleryView() {
        NSLayoutConstraint.activate([
            self.screenshotGalleryView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor),
            self.screenshotGalleryView.topAnchor.constraint(
                equalTo: self.contentView.topAnchor),
            self.screenshotGalleryView.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor),
            self.screenshotGalleryView.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor)
        ])
    }

}

extension AppDetailScreenshotCollectionViewCell: ScreenshotGalleryViewModel {
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return appDetail?.screenShotURLs?.count ?? .zero
    }
    
    func screenshotURLForCell(at indexPath: IndexPath) -> String? {
        return appDetail?.screenShotURLs?[indexPath.row]
    }
    
}

extension AppDetailScreenshotCollectionViewCell: ScreenshotGalleryViewDelegate {
    
    func didTappedScreenshot(_ viewModel: ScreenshotGalleryViewModel) {
        appDetailTableViewCellDelegate?.screenshotDidTapped(viewModel)
    }

}
