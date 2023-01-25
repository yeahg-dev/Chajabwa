//
//  AppFolderListViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/18.
//

import Combine
import UIKit

class AppFolderListViewController: UIViewController {

    private let viewModel = AppFolderListViewModel()
    
    private let appFolderCellDidSelected = PassthroughSubject<IndexPath, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var folderCreationButton: AppFolderCreationButton = {
        let button = AppFolderCreationButton(frame: .zero)
        let action = UIAction { [weak self] _ in
            self?.presentAppFolderCreatiorView()
        }
        button.addAction(action)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var appFolderTableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(cellWithClass: AppFolderTableViewCell.self)
        tableView.dataSource = viewModel
        tableView.delegate = self
        tableView.backgroundColor = Design.backgroundColor
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Design.backgroundColor
        addSubviews()
        setConstraints()
        configureNavigationBar()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshView()
    }
    
    private func addSubviews() {
        view.addSubview(folderCreationButton)
        view.addSubview(appFolderTableView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            folderCreationButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            folderCreationButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            folderCreationButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            appFolderTableView.topAnchor.constraint(
                equalTo: folderCreationButton.bottomAnchor),
            appFolderTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            appFolderTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            appFolderTableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = Design.navigationBarTintColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : Design.navigtaionBarTitleTextColor]
    }
    
    private func bind() {
        let input = AppFolderListViewModel.Input(
            appFolderCellDidSelected: appFolderCellDidSelected.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        navigationItem.title = output.navigationTitle
        output.slectedAppFolder
            .receive(on: RunLoop.main)
            .sink { [weak self] appFolder in
                self?.pushAppFolderDetailView(appFolder) }
            .store(in: &cancellables)
    }
    
    func refreshAppFolderTableView()  {
        Task {
            await viewModel.fetchLatestData()
            await MainActor.run{
                appFolderTableView.reloadData()
            }
        }
    }
    
    private func pushAppFolderDetailView(_ appFolder: AppFolder?) {
        guard let appFolder else {
            print("appFolder does not exist")
            return
        }
        let appFolderDetailView = AppFolderDetailViewController(appFolder: appFolder)
        navigationController?.pushViewController(appFolderDetailView, animated: true)
    }
    
    private func presentAppFolderCreatiorView() {
        let view = AppFolderCreatorViewController()
        view.appFolderCreatorViewPresenting = self
        modalPresentationStyle = .formSheet
        present(view, animated: true)
    }

}

// MARK: - UITableViewDelegate

extension AppFolderListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appFolderCellDidSelected.send(indexPath)
    }

}

// MARK: - AppFolderCreatorViewPresenting

extension AppFolderListViewController: AppFolderCreatorViewPresenting {
    
    func refreshView() {
        refreshAppFolderTableView()
    }
    
}

private enum Design {
    
    static let backgroundColor: UIColor = Color.favoriteLavender
    static let navigationBarTintColor = Color.blueGreen
    static let navigtaionBarTitleTextColor: UIColor = .black
    
}
