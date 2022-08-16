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
    
    func ScreenshotURLForCell(at indexPath: IndexPath) -> String?
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
    
    private let screenshotCollectionView = UICollectionView()
    
    private var viewModel : Observable<ScreenshotGalleryViewModel>
    weak var delegate: ScreenshotGallerViewDelegate?
    
    private let design: ScreenshotGalleryDesign.Type
    
    init(viewModel: Observable<ScreenshotGalleryViewModel>,
         style: ScreenshotGalleryStyle) {
        self.viewModel = viewModel
        self.design = style.design
        super.init(frame: .zero)
        self.configureCollectionView()
        self.bind(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        self.setConstraints()
        self.configureCollectionViewLayout()
        self.screenshotCollectionView.dataSource = self
        self.screenshotCollectionView.delegate = self
        self.screenshotCollectionView.register(ScreenShotCollectionViewCell.self)
    }
    
    private func setConstraints() {
        self.addSubview(screenshotCollectionView)
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
    
    private func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = design.minimumLineSpacing
        layout.sectionInset = UIEdgeInsets(
            top: design.topSectionInset,
            left: design.leftSectionInset,
            bottom: design.bottomSectionInset,
            right: design.rightSectionInset)
        self.screenshotCollectionView.collectionViewLayout = layout
    }
    
    private func bind(_ viewModel: Observable<ScreenshotGalleryViewModel>) {
        viewModel.observe(on: self) { _ in
            self.screenshotCollectionView.reloadData()
        }
    }
    
}

extension ScreenshotGalleryView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.value.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let urlString = self.viewModel.value.ScreenshotURLForCell(at: indexPath) else {
            return ScreenShotCollectionViewCell()
        }
        
        let cell = self.screenshotCollectionView.dequeueReusableCell(ScreenShotCollectionViewCell.self, for: indexPath)
        cell.fill(with: urlString)
        
        return cell
    }
    
}

extension ScreenshotGalleryView: UICollectionViewDelegate {
    
}
