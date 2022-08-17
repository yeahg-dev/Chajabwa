//
//  ScreenshotGalleryView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/16.
//

import UIKit

protocol ScreenshotGallerViewDelegate: AnyObject {
    
    // 셀 탭시 행동 정의
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
    
    // TODO: - 코드 정리
    private lazy var screenshotCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = design.minimumLineSpacing
        let screenshotHeight = UIScreen.main.bounds.height * 0.55
        let screenshotWidth = screenshotHeight * 0.56
        layout.itemSize = CGSize(width: screenshotWidth, height: screenshotHeight)
        layout.sectionInset = UIEdgeInsets(
            top: design.topSectionInset,
            left: design.leftSectionInset,
            bottom: design.bottomSectionInset,
            right: design.rightSectionInset)
        return UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
    }()
    
    private let design: ScreenshotGalleryDesign.Type
    
    var viewModel: ScreenshotGalleryViewModel? {
        didSet {
            self.screenshotCollectionView.reloadData()
        }
    }
    weak var delegate: ScreenshotGallerViewDelegate?
    
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
        let screenshotCollectionViewHeightAchor = screenshotCollectionView.heightAnchor.constraint(
            equalToConstant: (UIScreen.main.bounds.height * 0.55) + design.topSectionInset + design.bottomSectionInset)
        screenshotCollectionViewHeightAchor.priority = .defaultHigh
        let screenshotCollectionViewWidthAchor =  screenshotCollectionView.widthAnchor.constraint(
            equalToConstant: UIScreen.main.bounds.width)
        screenshotCollectionViewWidthAchor.priority = .defaultHigh
        NSLayoutConstraint.activate([
            screenshotCollectionView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor),
            screenshotCollectionView.topAnchor.constraint(
                equalTo: self.topAnchor),
            screenshotCollectionView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor),
            screenshotCollectionView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor),
           screenshotCollectionViewWidthAchor,
            screenshotCollectionViewHeightAchor
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
    
}
