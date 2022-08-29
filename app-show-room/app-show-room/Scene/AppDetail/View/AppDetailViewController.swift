//
//  AppDetailViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/17.
//

import UIKit

final class AppDetailViewController: UIViewController, UICollectionViewDelegate {
    
    private var contentCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<AppDetailViewModel.Section, AppDetailViewModel.Item>!
    
    private let viewModel: AppDetailViewModel
    
    init(appDetailViewModel: AppDetailViewModel) {
        self.viewModel = appDetailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.configureUI()
        self.configureContentCollectioView()
        self.configureDataSource()
        self.addSubviews()
        self.setContstraints()
        self.applyInitialSnapshot()
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureContentCollectioView() {
        self.contentCollectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createLayout())
    }
    
    private func addSubviews() {
        self.view.addSubview(contentCollectionView)
    }
    
    private func setContstraints() {
        self.contentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.contentCollectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            self.contentCollectionView.topAnchor.constraint(
                equalTo: safeArea.topAnchor),
            self.contentCollectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            self.contentCollectionView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = AppDetailViewModel.Section(rawValue: sectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            if sectionKind == .summary {
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(AppDetailSummaryDesign.height))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                
            } else if sectionKind == .screenshot {
    
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(280),
                    heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(280),
                    heightDimension: .estimated(500))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.orthogonalScrollingBehavior = .groupPaging
                
            } else if sectionKind == .descritption {
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            } else {
                fatalError("Unknown section!")
            }
            
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    private func createSummaryCellRegistration() -> UICollectionView.CellRegistration<AppDetailSummaryCollectionViewCell, AppDetailViewModel.Item> {
        return UICollectionView.CellRegistration<AppDetailSummaryCollectionViewCell, AppDetailViewModel.Item> { (cell, indexPath, item) in
            cell.bind(model: item)
        }
    }
    
    private func createScreenshotCellRegistration() -> UICollectionView.CellRegistration<ScreenShotCollectionViewCell, AppDetailViewModel.Item> {
        return UICollectionView.CellRegistration<ScreenShotCollectionViewCell, AppDetailViewModel.Item> { (cell, indexPath, item) in
            guard case let .screenshot(screenshotData) = item else {
               return
            }
            cell.fill(with: screenshotData.url)
        }
    }
    
    private func createDescriptionCellRegistration() -> UICollectionView.CellRegistration<AppDetailDescriptionCollectionViewCell, AppDetailViewModel.Item> {
        return UICollectionView.CellRegistration<AppDetailDescriptionCollectionViewCell, AppDetailViewModel.Item> { (cell, indexPath, item) in
            cell.bind(model: item)
        }
    }
    
    private func configureDataSource() {
        let summaryCellRegistration = createSummaryCellRegistration()
        let screenshotCellRegistration = createScreenshotCellRegistration()
        let descriptionCellRegistration = createDescriptionCellRegistration()
        
        self.dataSource = UICollectionViewDiffableDataSource<AppDetailViewModel.Section, AppDetailViewModel.Item>(collectionView: contentCollectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = AppDetailViewModel.Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            
            switch section {
            case .summary:
                return collectionView.dequeueConfiguredReusableCell(
                    using: summaryCellRegistration,
                    for: indexPath,
                    item: item)
            case .screenshot:
                // TODO: - Type 리턴하도록
                return collectionView.dequeueConfiguredReusableCell(
                        using: screenshotCellRegistration,
                        for: indexPath,
                        item: item)
            case .descritption:
                return collectionView.dequeueConfiguredReusableCell(
                    using: descriptionCellRegistration,
                    for: indexPath,
                    item: item)
            }

        }
    }
    
    private func applyInitialSnapshot() {
        // set the order for our sections
        
        let sections = AppDetailViewModel.Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<AppDetailViewModel.Section, AppDetailViewModel.Item>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        sections.forEach { section in
            var snapshot = NSDiffableDataSourceSectionSnapshot<AppDetailViewModel.Item>()
            let items = viewModel.cellItems(at: section.rawValue)
            snapshot.append(items)
            dataSource.apply(snapshot, to: section, animatingDifferences: false)
            }
    }
    
}

extension AppDetailViewController: AppDetailTableViewCellDelegate {
    
    func foldingButtonDidTapped() {
        self.contentCollectionView.performBatchUpdates(nil)
    }
    
    func screenshotDidTapped(_ viewModel: ScreenshotGalleryViewDataSource) {
        let screenshotViewController = EnlargedScreenshotGalleryViewController(
            viewModel: viewModel)
        self.present(screenshotViewController, animated: true)
        screenshotViewController.modalPresentationStyle = .fullScreen
    }
    
}
