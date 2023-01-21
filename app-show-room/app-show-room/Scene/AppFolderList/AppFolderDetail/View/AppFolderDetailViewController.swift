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
    
    private lazy var savedAppDetailTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(cellWithClass: SavedAppDetailTableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.dataSource = viewModel
        tableView.delegate = self
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Design.backgroundColor
        configureNavigationBar()
        addSubviews()
        setConstraints()
        self.headerView = AppFolderDetailHeaderView()
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        headerView.translatesAutoresizingMaskIntoConstraints = true
        headerView.frame = .init(origin: .zero, size: size)
        savedAppDetailTableView.tableHeaderView = headerView
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let appearacne = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = appearacne
    }
    
    private func configureNavigationBar() {
        let editButton = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(rightNavigationBarButtonDidTapped))
        navigationController?.navigationItem.setRightBarButton(editButton, animated: true)
        let appearacne = UINavigationBarAppearance()
        appearacne.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearacne
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
    
    // TODO: - Refactoring
    private func bind() {
        let input = AppFolderDetailViewModel.Input(selectedIndexPath: cellDidSelectedAt.eraseToAnyPublisher())
        Task {
            let output = await viewModel.transform(input)
            await MainActor.run {
                headerView.bind(iconImageURL: output.iconImagURL, blurImage: output.blurIconImage, name: output.appFolderName, description: output.appFolderDescription)
            }
        }
    }
    
    private func pushAppDetailView(of savedApp: SavedApp?) {
        
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
