//
//  AppDetailScreenshotTableViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

final class AppDetailScreenshotTableViewCell: BaseAppDetailTableViewCell {
    
    override var height: CGFloat { UIScreen.main.bounds.height * 0.55 }
    
    private var screenshotGalleryView: ScreenshotGalleryView!
    
    private var appDetail: AppDetail?
    
    override func configureSubviews() {
        self.addSubviews()
        self.setConstraintsSubviews()
    }

    override func bind(model: BaseAppDetailTableViewCellModel) {
        self.appDetail = model.app
    }
  
    private func addSubviews() {
        self.screenshotGalleryView = ScreenshotGalleryView(
            viewModel: self,
            style: .embeddedInAppDetailScene)
        self.contentView.addSubview(screenshotGalleryView)
    }
    
    private func setConstraintsSubviews() {
        NSLayoutConstraint.activate([
            self.screenshotGalleryView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.screenshotGalleryView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.screenshotGalleryView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.screenshotGalleryView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}

extension AppDetailScreenshotTableViewCell: ScreenshotGalleryViewModel {
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return appDetail?.screenShotURLs?.count ?? .zero
    }
    
    func screenshotURLForCell(at indexPath: IndexPath) -> String? {
        return appDetail?.screenShotURLs?[indexPath.row]
    }
    
}
