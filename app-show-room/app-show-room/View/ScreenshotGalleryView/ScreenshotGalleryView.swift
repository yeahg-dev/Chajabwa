//
//  ScreenshotGalleryView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

protocol ScreenshotGalleryViewDelegate: AnyObject {
    
    func didTappedScreenshot(_ viewModel: ScreenshotGalleryViewDataSource)
    
}

protocol ScreenshotGalleryViewDataSource {
    
    func numberOfItemsInSection(_ section: Int) -> Int
    
    func screenshotURLForCell(at indexPath: IndexPath) -> String?
    
}

final class ScreenshotGalleryView: UIView {
    
    private lazy var screenshotCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = design.minimumLineSpacing
        layout.itemSize = CGSize(
            width: design.cellWidth,
            height: design.cellHeight)
        layout.sectionInset = UIEdgeInsets(
            top: design.topSectionInset,
            left: design.leadingSectionInset,
            bottom: design.bottomSectionInset,
            right: design.trailingSectionInset)
        return UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
    }()
    
    let design: ScreenshotGalleryDesign.Type
    
    var viewModel: ScreenshotGalleryViewDataSource?
    weak var delegate: ScreenshotGalleryViewDelegate?
    
    init(viewModel: ScreenshotGalleryViewDataSource,
         style: ScreenshotGalleryStyle) {
        self.viewModel = viewModel
        design = style.design
        super.init(frame: .zero)
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        screenshotCollectionView.reloadData()
    }
    
    private func configureCollectionView() {
        setConstraintsOfView()
        setScreenshotCollectionViewConstraints()
        screenshotCollectionView.dataSource = self
        screenshotCollectionView.delegate = self
        screenshotCollectionView.showsHorizontalScrollIndicator = false
        screenshotCollectionView.register(ScreenShotCollectionViewCell.self)
    }
    
    private func setConstraintsOfView() {
        let screenShotGalleryViewWidthConstraint = self.widthAnchor.constraint(
            equalToConstant: design.screenShotGalleryViewWidth)
        screenShotGalleryViewWidthConstraint.priority = .defaultHigh
        let screenShotGalleryViewHeightConstraint = self.heightAnchor.constraint(
            equalToConstant: design.screenShotGalleryViewHeight)
        screenShotGalleryViewHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            screenShotGalleryViewWidthConstraint,
            screenShotGalleryViewHeightConstraint
        ])
    }
    
    private func setScreenshotCollectionViewConstraints() {
        self.addSubview(screenshotCollectionView)
        self.screenshotCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            screenshotCollectionView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor),
            screenshotCollectionView.topAnchor.constraint(
                equalTo: self.topAnchor),
            screenshotCollectionView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor),
            screenshotCollectionView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor),
            screenshotCollectionView.heightAnchor.constraint(
                equalTo: self.heightAnchor)
        ])
    }
    
}


extension ScreenshotGalleryView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItemsInSection(section) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let urlString = viewModel?.screenshotURLForCell(at: indexPath) else {
            return ScreenShotCollectionViewCell()
        }
        
        let cell = screenshotCollectionView.dequeueReusableCell(ScreenShotCollectionViewCell.self, for: indexPath)
        cell.fill(with: urlString)
        
        return cell
    }
    
}

extension ScreenshotGalleryView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        self.delegate?.didTappedScreenshot(viewModel)
    }
    
}
