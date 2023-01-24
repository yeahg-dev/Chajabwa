//
//  ScreenshotGalleryViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/17.
//

import UIKit

final class ScreenshotGalleryViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(
            width: ScreenShotCollectionViewCellStyle.Large.width,
            height: ScreenShotCollectionViewCellStyle.Large.height)
        layout.minimumLineSpacing = CGFloat(15)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 20, right: 35)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private lazy var doneButton: UIButton = {
        let action = UIAction { _ in self.dismiss(animated: true) }
        let button = UIButton(type: .system, primaryAction: action)
        button.setTitleColor(Color.blueGreen, for: .normal)
        return button
    }()
    
    private var viewModel: ScreenshotGalleryViewModel
    
    init(viewModel: ScreenshotGalleryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.lightSkyBlue
        view.addSubview(collectionView)
        view.addSubview(doneButton)
        configureCollectionView()
        configureDoneButton()
        setConstraints()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.register(LargeScreenshotCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Color.lightSkyBlue
    }
    
    private func configureDoneButton() {
        doneButton.setTitle(viewModel.doneButtonTitle, for: .normal)
    }

    private func setConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            doneButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -15),
            doneButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)
        ])
    }
    
}

extension ScreenshotGalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let urlString = viewModel.cellItem(at: indexPath) else {
            return LargeScreenshotCollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(
            LargeScreenshotCollectionViewCell.self,
            for: indexPath)
        cell.fill(with: urlString)
        
        return cell
    }
    
}
