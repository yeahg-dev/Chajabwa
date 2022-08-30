//
//  AppDetailViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/17.
//

import UIKit

final class AppDetailViewController: UIViewController {
    
    private var contentCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<AppDetailViewModel.Section, AppDetailViewModel.Item>!
    
    private let viewModel: AppDetailViewModel
    
    private lazy var iconImage: IconView = {
       let iconIamge = IconView()
        iconIamge.setImage(withURL: viewModel.iconImageURL)
        return iconIamge
    }()
    
    private var isNavigationItemHidden: Bool = true
    private var isDescriptionViewFolded: Bool = true
    
    init(appDetailViewModel: AppDetailViewModel) {
        viewModel = appDetailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureUI()
        configureContentCollectioView()
        configureDataSource()
        addSubviews()
        setContstraints()
        applyInitialSnapshot()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.titleView = iconImage
        navigationItem.titleView?.alpha = 0
        navigationItem.titleView?.isHidden = true
        let downloadButton =  UIBarButtonItem(customView: DownloadButtonView())
        navigationItem.setRightBarButton(downloadButton, animated: false)
        navigationItem.rightBarButtonItem?.customView?.alpha = 0
    }
    
    private func configureContentCollectioView() {
        contentCollectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createLayout())
        contentCollectionView.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(contentCollectionView)
    }
    
    private func setContstraints() {
        contentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentCollectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            contentCollectionView.topAnchor.constraint(
                equalTo: view.topAnchor),
            contentCollectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            contentCollectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = AppDetailViewModel.Section(rawValue: sectionIndex) else {
                return nil }
            
            let section: NSCollectionLayoutSection
            
            if sectionKind == .summary {
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(AppDetailSummaryDesign.height))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                
            } else if sectionKind == .screenshot {
                
                let cellDesign = ScreenShotCollectionViewCellStyle.Normal.self
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(cellDesign.width),
                    heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(cellDesign.width),
                    heightDimension: .estimated(cellDesign.height))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 20, leading: 25, bottom: 20, trailing: 25)
                section.orthogonalScrollingBehavior = .groupPaging
                
            } else if sectionKind == .descritption {
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(200))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(200))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitems: [item])
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
            cell.delegate = self
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

extension AppDetailViewController: AppDetailDescriptionCollectionViewCellDelegate {
    
    func foldingButtonDidTapped() {
        isDescriptionViewFolded.toggle()
        var snapshot = NSDiffableDataSourceSectionSnapshot<AppDetailViewModel.Item>()
        let description = viewModel.description(isTruncated: isDescriptionViewFolded)
        snapshot.append([description])
        
        dataSource.apply(snapshot, to: .descritption)
    }
    
}

extension AppDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        guard .screenshot == AppDetailViewModel.Section(rawValue: section) else {
            return
        }
        
        let screenshotGalleryViewModel = ScreenshotGalleryViewModel(
            screenshotURLs: viewModel.screenshotURLs)
        let screenshotGalleryVC = ScreenshotGalleryViewController(
            viewModel: screenshotGalleryViewModel)
        screenshotGalleryVC.modalPresentationStyle = .overFullScreen
        present(screenshotGalleryVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if contentCollectionView.contentOffset.y > 45 && isNavigationItemHidden {
            isNavigationItemHidden.toggle()
            navigationItem.titleView?.isHidden = false
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    self.navigationItem.titleView?.alpha = 1
                    self.navigationItem.rightBarButtonItem?.customView?.alpha = 1
                } ,
                completion: nil)
        } else if contentCollectionView.contentOffset.y < 45 && isNavigationItemHidden == false {
            isNavigationItemHidden.toggle()
            self.navigationItem.titleView?.alpha = 0
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 0
        }
    }
    
}
