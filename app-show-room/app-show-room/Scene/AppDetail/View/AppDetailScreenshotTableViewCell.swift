//
//  AppDetailScreenshotTableViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

protocol ScreenShotCollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int

    func collectionView(_ collectionView: UICollectionView, screenShotForItemAt indexPath: IndexPath) -> String?
}

final class AppDetailScreenshotTableViewCell: BaseAppDetailTableViewCell {
    
    override var height: CGFloat { UIScreen.main.bounds.height * 0.55 }
    
    private var screenShotCollectionViewDataSource: ScreenShotCollectionViewDataSource?
    private let screenShotCollectionView = UICollectionView()
    
    override func configureSubviews() {
       
    }

    override func bind(model: BaseAppDetailTableViewCellModel) {
        self.screenShotCollectionViewDataSource = model.screenShotCollectionViewDataSource
    }
    
    private func configureScreenShotCollectionView() {
        self.screenShotCollectionView.dataSource = self
        self.screenShotCollectionView.delegate = self
    }
    
}

extension AppDetailScreenshotTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.screenShotCollectionViewDataSource?.collectionView(
            self.screenShotCollectionView,
            numberOfItemsInSection: section) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let url = self.screenShotCollectionViewDataSource?.collectionView(
            self.screenShotCollectionView,
            screenShotForItemAt: indexPath) else {
            return UICollectionViewCell()
        }
        
        return UICollectionViewCell()
    }
    
}

extension AppDetailScreenshotTableViewCell: UICollectionViewDelegate {
    
}
