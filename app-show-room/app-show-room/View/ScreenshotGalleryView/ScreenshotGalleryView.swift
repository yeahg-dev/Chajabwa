//
//  ScreenshotGalleryView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

protocol ScreenshotGalleryViewDelegate: AnyObject {
    
    func didTappedScreenshot(_ viewModel: ScreenshotGalleryViewModel)
    
}

protocol ScreenshotGalleryViewModel {
    
    func numberOfItemsInSection(_ section: Int) -> Int
    
    func screenshotURLForCell(at indexPath: IndexPath) -> String?
}


enum ScreenshotGalleryStyle {
    
    case embeddedInAppDetailScene
    case enlarged
    
    var design: ScreenshotGalleryDesign.Type {
        switch self {
        case .embeddedInAppDetailScene:
            return EmbeddedInAppDetailSceneDesign.self
        case .enlarged:
            return EnlargedSceneDesign.self
        }
    }
}

final class ScreenshotGalleryView: UIView {
    
    private lazy var screenshotCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = design.minimumLineSpacing
        layout.itemSize = CGSize(width: design.cellWidth, height: design.cellHeight)
        layout.sectionInset = UIEdgeInsets(
            top: design.topSectionInset,
            left: design.leftSectionInset,
            bottom: design.bottomSectionInset,
            right: design.rightSectionInset)
        return UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
    }()
    
    let design: ScreenshotGalleryDesign.Type
    
    var viewModel: ScreenshotGalleryViewModel? {
        didSet {
            self.screenshotCollectionView.reloadData()
        }
    }
    weak var delegate: ScreenshotGalleryViewDelegate?
    
    init(viewModel: ScreenshotGalleryViewModel,
         style: ScreenshotGalleryStyle) {
        self.viewModel = viewModel
        self.design = style.design
        super.init(frame: .zero)
        self.configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        self.setConstraints()
        self.screenshotCollectionView.dataSource = self
        self.screenshotCollectionView.delegate = self
        self.screenshotCollectionView.showsHorizontalScrollIndicator = false
        self.screenshotCollectionView.register(ScreenShotCollectionViewCell.self)
    }
    
    private func setConstraints() {
        self.addSubview(screenshotCollectionView)
        screenshotCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            screenshotCollectionView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor),
            screenshotCollectionView.topAnchor.constraint(
                equalTo: self.topAnchor),
            screenshotCollectionView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor),
            screenshotCollectionView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor)
        ])
    }
    
}

extension ScreenshotGalleryView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.numberOfItemsInSection(section) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let urlString = self.viewModel?.screenshotURLForCell(at: indexPath) else {
            return ScreenShotCollectionViewCell()
        }
        
        let cell = self.screenshotCollectionView.dequeueReusableCell(ScreenShotCollectionViewCell.self, for: indexPath)
        cell.fill(with: urlString)
        
        return cell
    }
    
}

extension ScreenshotGalleryView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = self.viewModel else { return }
        self.delegate?.didTappedScreenshot(viewModel)
    }
    
}
