//
//  AppDetailViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/17.
//

import UIKit

final class AppDetailViewController: UIViewController {
    
    private let contentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
    }()
    
    private let viewModel: AppDetailViewModel
    
    init(appDetailViewModel: AppDetailViewModel) {
        self.viewModel = appDetailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.designView()
        self.configureContentCollectioView()
        self.addSubviews()
        self.setContstraints()
        self.contentCollectionView.reloadData()
    }
    private func designView() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureContentCollectioView() {
        self.contentCollectionView.dataSource = self
        self.contentCollectionView.delegate = self
        self.viewModel.contentSections.forEach { section in
            let cellClass = section.cellType
            self.contentCollectionView.register(cellClass)
        }
    }
    
    private func addSubviews() {
        self.view.addSubview(contentCollectionView)
    }
    
    private func setContstraints() {
        self.contentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.contentCollectionView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor),
            self.contentCollectionView.topAnchor.constraint(
                equalTo: safeArea.topAnchor),
            self.contentCollectionView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor),
            self.contentCollectionView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor)
        ])
    }
    
}

extension AppDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = self.viewModel.cellHeight(at: indexPath)
        
        return CGSize(width: width, height: height)
    }
    
}

// MARK: - UICollectionViewDataSource

extension AppDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.numberOfSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = viewModel.cellType(at: indexPath)
        let cell = collectionView.dequeueReusableCell(cellType, for: indexPath)
        
        let cellModel = viewModel.cellModel(at: indexPath)
        cell.bind(model: cellModel)
        
        return cell
    }
    
}

extension AppDetailViewController: UICollectionViewDelegate {
    
    
}
