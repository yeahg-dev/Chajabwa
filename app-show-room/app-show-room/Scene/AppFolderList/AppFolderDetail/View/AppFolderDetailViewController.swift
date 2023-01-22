//
//  AppFolderDetailViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/21.
//

import Combine
import UIKit

class AppFolderDetailViewController: UIViewController {
    
    private let viewModel: AppFolderDetailViewModel
    
    init(appFolder: AppFolder) {
        viewModel = AppFolderDetailViewModel(appFolder)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let cellDidSelectedAt = PassthroughSubject<IndexPath, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var headerView: AppFolderDetailHeaderView!
    
    private lazy var emptyView = AppFolderDetailTableViewEmptyView(
        frame: .zero,
        goToSearchButtonAction: UIAction(handler: { [weak self] _ in
            self?.navigateToSearchView()
        })
    )
    
    private lazy var savedAppDetailTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(cellWithClass: SavedAppDetailTableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.dataSource = viewModel
        tableView.delegate = self
        tableView.backgroundView = emptyView
        tableView.backgroundView?.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Design.backgroundColor
        configureNavigationBar()
        configureHeaderView()
        addSubviews()
        setConstraints()
        bind()
    }
    
    private func configureHeaderView() {
        savedAppDetailTableView.contentInsetAdjustmentBehavior = .never
        edgesForExtendedLayout = .all
        self.headerView = AppFolderDetailHeaderView()
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        headerView.translatesAutoresizingMaskIntoConstraints = true
        headerView.frame = .init(origin: .zero, size: size)
        savedAppDetailTableView.tableHeaderView = headerView
    }

    private func configureNavigationBar() {
        let editButton = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(rightNavigationBarButtonDidTapped))
        navigationItem.rightBarButtonItem = editButton
        navigationController?.navigationItem.setRightBarButton(editButton, animated: true)
        let appearacne = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = appearacne
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.configureWithTransparentBackground()
        scrollAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.scrollEdgeAppearance = scrollAppearance
    }
    
    private func addSubviews() {
        view.addSubview(savedAppDetailTableView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            savedAppDetailTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            savedAppDetailTableView.topAnchor.constraint(
                equalTo: view.topAnchor),
            savedAppDetailTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            savedAppDetailTableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)
        ])
    }
    
    @objc
    private func rightNavigationBarButtonDidTapped() {
        
    }
    
    private func bind() {
        let input = AppFolderDetailViewModel.Input(selectedIndexPath: cellDidSelectedAt.eraseToAnyPublisher())
        let output = viewModel.transform(input)
        
        emptyView.bind(
            guideLabelText: output.EmptyViewguideLabelText,
            goToSearchButtonTitle: output.goToSearchButtonTitle)
        output.showEmptyView
            .receive(on: RunLoop.main)
            .sink { showEmptyView in
                self.savedAppDetailTableView.backgroundView?.isHidden = !showEmptyView
            }.store(in: &cancellables)
        headerView.bind(
            iconImageURL: output.iconImagURL,
            blurImageURL: output.blurIconImageURL,
            name: output.appFolderName,
            description: output.appFolderDescription)
        }
    
    private func pushAppDetailView(of savedApp: SavedApp?) {
        
    }
    
    private func navigateToSearchView() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension AppFolderDetailViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        cellDidSelectedAt.send(indexPath)
    }

}

private enum Design {
    
    static let backgroundColor: UIColor = Color.favoriteLavender
    static let navigationBarTintColor = Color.blueGreen

}
