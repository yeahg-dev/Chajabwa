//
//  AppDetailViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/17.
//

import UIKit
import SafariServices

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
    private var isReleaseNoteFolded: Bool = true
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
            
            switch sectionKind {
            case .signBoard:
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(SignboardCollectionViewCellDesign.height))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            case .summary:
                
                let cellDesign = SummaryCollectionViewCellDesign.self
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(cellDesign.width),
                    heightDimension: .absolute(cellDesign.height))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 20, leading: 25, bottom: 20, trailing: 25)
                section.orthogonalScrollingBehavior = .continuous
                
            case .releaseNote:
                
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
            case .screenshot:
                
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
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(44)),
                    elementKind: "Header",
                    alignment: .top)
               
                section.boundarySupplementaryItems = [sectionHeader]
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 20, leading: 25, bottom: 20, trailing: 25)
                section.orthogonalScrollingBehavior = .groupPaging
                
            case .descritption:
                
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
                
            case .information:
                
                let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
                section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            }

            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    private func createSignboardCellRegistration() -> UICollectionView.CellRegistration<SignboardCollectionViewCell, AppDetailViewModel.Item> {
        return UICollectionView.CellRegistration<SignboardCollectionViewCell, AppDetailViewModel.Item> { (cell, indexPath, item) in
            cell.bind(model: item)
        }
    }
    
    private func createSummaryCellRegistration() -> UICollectionView.CellRegistration<SummaryCollectionViewCell, AppDetailViewModel.Item> {
        return UICollectionView.CellRegistration<SummaryCollectionViewCell, AppDetailViewModel.Item> { [weak self] (cell, indexPath, item) in
            guard case let .summary(summary) = item else {
                return
            }
            cell.bind(
                primaryText: summary.primaryText,
                secondaryText: summary.secnondaryText,
                symbolImage: summary.symbolImage)
            
            if indexPath.row == (self?.viewModel.summaryCollectionViewCellCount ?? 0) - 1 {
                cell.showsSeparator = false
            } else {
                cell.showsSeparator = true
            }
            
        }
    }
    
    private func createReleaseNoteCellRegistration() -> UICollectionView.CellRegistration<ReleaseNoteCollectionViewCell, AppDetailViewModel.Item> {
        return UICollectionView.CellRegistration<ReleaseNoteCollectionViewCell, AppDetailViewModel.Item> { (cell, indexPath, item) in
            cell.bind(model: item)
            cell.delegate = self
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
    
    private func createTextInformationCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, AppDetailViewModel.Item> {
        return UICollectionView.CellRegistration<UICollectionViewCell, AppDetailViewModel.Item> { (cell, indexPath, item) in
            guard case let .information(information) = item else {
                return
            }
            var content = UIListContentConfiguration.valueCell()
            
            content.text = information.category
            content.textProperties.font = .preferredFont(forTextStyle: .callout)
            content.textProperties.color = .systemGray
            content.secondaryText = information.value
            content.secondaryTextProperties.font = .preferredFont(forTextStyle: .callout)
            content.secondaryTextProperties.color = .label
            cell.contentConfiguration = content
        }
    }
    
    private func createLinkInformationCellRegistration() -> UICollectionView.CellRegistration<LinkInformationCollectionViewCell, AppDetailViewModel.Item> {
        return UICollectionView.CellRegistration<LinkInformationCollectionViewCell, AppDetailViewModel.Item> { (cell, indexPath, item) in
            guard case let .information(information) = item else {
                return
            }
            
            cell.bind(image: information.image, category: information.category)
        }
    }
    
    private func createDescriptionCellRegistration() -> UICollectionView.CellRegistration<DescriptionCollectionViewCell, AppDetailViewModel.Item> {
        return UICollectionView.CellRegistration<DescriptionCollectionViewCell, AppDetailViewModel.Item> { (cell, indexPath, item) in
            cell.bind(model: item)
            cell.delegate = self
        }
    }
    
    private func createHeaderSupplemantryRegistration() -> UICollectionView.SupplementaryRegistration
    <TitleSupplementaryView> {
        return UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: "Header") {
            [weak self] (supplementaryView, string, indexPath) in
            let sectionTitle = self?.viewModel.sections[indexPath.section].title
            supplementaryView.bind(title: sectionTitle)
        }
    }
        
    private func configureDataSource() {
        let signboardCellRegistration = createSignboardCellRegistration()
        let summaryCellRegistration = createSummaryCellRegistration()
        let releaseNoteCellRegistration = createReleaseNoteCellRegistration()
        let screenshotCellRegistration = createScreenshotCellRegistration()
        let descriptionCellRegistration = createDescriptionCellRegistration()
        let textInformationCellRegistration = createTextInformationCellRegistration()
        let linkInformationCellRegistration = createLinkInformationCellRegistration()
        let headerSupplemantryRegistration = createHeaderSupplemantryRegistration()
        
        self.dataSource = UICollectionViewDiffableDataSource<AppDetailViewModel.Section, AppDetailViewModel.Item>(collectionView: contentCollectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = AppDetailViewModel.Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            
            switch section {
            case .signBoard:
                return collectionView.dequeueConfiguredReusableCell(
                    using: signboardCellRegistration,
                    for: indexPath,
                    item: item)
            case .summary:
                return collectionView.dequeueConfiguredReusableCell(
                    using: summaryCellRegistration,
                    for: indexPath,
                    item: item)
            case .releaseNote:
                return collectionView.dequeueConfiguredReusableCell(
                    using: releaseNoteCellRegistration,
                    for: indexPath,
                    item: item)
            case .screenshot:
                return collectionView.dequeueConfiguredReusableCell(
                    using: screenshotCellRegistration,
                    for: indexPath,
                    item: item)
            case .descritption:
                return collectionView.dequeueConfiguredReusableCell(
                    using: descriptionCellRegistration,
                    for: indexPath,
                    item: item)
            case .information:
                
                if self.viewModel.linkInformationsIndexPaths.contains(indexPath) {
                    return collectionView.dequeueConfiguredReusableCell(
                        using: linkInformationCellRegistration,
                        for: indexPath,
                        item: item)
                } else {
                    return collectionView.dequeueConfiguredReusableCell(
                        using: textInformationCellRegistration,
                        for: indexPath,
                        item: item)
                }
            }
        }
        self.dataSource.supplementaryViewProvider = { [weak self] (view, kind, index) in
            return self?.contentCollectionView.dequeueConfiguredReusableSupplementary(
                using: headerSupplemantryRegistration, for: index)
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

extension AppDetailViewController: DescriptionCollectionViewCellDelegate {
    
    func foldingButtonDidTapped(_ : DescriptionCollectionViewCell) {
        isDescriptionViewFolded.toggle()
        var snapshot = NSDiffableDataSourceSectionSnapshot<AppDetailViewModel.Item>()
        let description = viewModel.description(isTruncated: isDescriptionViewFolded)
        snapshot.append([description])
        
        dataSource.apply(snapshot, to: .descritption)
    }
    
}

extension AppDetailViewController: ReleaseNoteCollectionViewCellDelegate {
    
    func foldingButtonDidTapped(_ : ReleaseNoteCollectionViewCell) {
        isReleaseNoteFolded.toggle()
        var snapshot = NSDiffableDataSourceSectionSnapshot<AppDetailViewModel.Item>()
        let releaseNote = viewModel.releaseNote(isTruncated: isReleaseNoteFolded)
        snapshot.append([releaseNote])
        
        dataSource.apply(snapshot, to: .releaseNote)
    }
    
}

extension AppDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        
        if .screenshot == AppDetailViewModel.Section(rawValue: section) {
            let screenshotGalleryViewModel = ScreenshotGalleryViewModel(
                screenshotURLs: viewModel.screenshotURLs)
            let screenshotGalleryVC = ScreenshotGalleryViewController(
                viewModel: screenshotGalleryViewModel)
            screenshotGalleryVC.modalPresentationStyle = .overFullScreen
            present(screenshotGalleryVC, animated: true)
        }
        
        if .information == AppDetailViewModel.Section(rawValue: section) && viewModel.linkInformationsIndexPaths.contains(indexPath) {
            
            guard let item: AppDetailViewModel.Item = dataSource.itemIdentifier(for: indexPath),
                  case let .information(information) = item,
                  let urlString = information.value else {
                return
            }
            let developerWebsiteURL = NSURL(string: urlString)
            let developerWebsiteView = SFSafariViewController(url: developerWebsiteURL as! URL)
            self.present(developerWebsiteView, animated: true, completion: nil)
        }
        
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
