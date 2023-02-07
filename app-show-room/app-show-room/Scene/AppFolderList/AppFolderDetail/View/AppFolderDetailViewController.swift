//
//  AppFolderDetailViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/21.
//

import Combine
import UIKit

class AppFolderDetailViewController: UIViewController {
    
    weak var coordinator: AppFolderDetailCoordinator?
    
    private let viewModel: AppFolderDetailViewModel
    
    init(appFolder: AppFolder) {
        viewModel = AppFolderDetailViewModel(appFolder.identifier)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        coordinator?.didFinish()
    }
    
    private let viewWillRefresh = PassthroughSubject<Void, Never>()
    private let cellDidSelectedAt = PassthroughSubject<IndexPath, Never>()
    private let cellWillDeletedAt = PassthroughSubject<IndexPath, Never>()
    private let editButtonDidTapped = PassthroughSubject<Void, Never>()
    private let deleteActionDidTapped = PassthroughSubject<Void, Never>()
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
        tableView.prefetchDataSource = viewModel
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillRefresh.send(())
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
            action: #selector(editBarButtonDidTapped))
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
    
    private func bind() {
        let input = AppFolderDetailViewModel.Input(
            viewWillRefresh: viewWillRefresh.eraseToAnyPublisher(),
            selectedIndexPath: cellDidSelectedAt.eraseToAnyPublisher(),
            cellWillDeleteAt: cellWillDeletedAt.eraseToAnyPublisher(),
            editButtonDidTapped: editButtonDidTapped.eraseToAnyPublisher(),
            deleteButtonDidTapped: deleteActionDidTapped.eraseToAnyPublisher()
        )
        let output = viewModel.transform(input)
        
        emptyView.bind(
            guideLabelText: output.EmptyViewguideLabelText,
            goToSearchButtonTitle: output.goToSearchButtonTitle)
        
        output.showEmptyView
            .receive(on: RunLoop.main)
            .sink { [weak self] showEmptyView in
                self?.savedAppDetailTableView.backgroundView?.isHidden = !showEmptyView
            }.store(in: &cancellables)
        
        output.selectedSavedAppDetail
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { [weak self] appDetail in
                self?.pushAppDetailView(of: appDetail)
            }).store(in: &cancellables)
        
        output.cellDidDeletedAt
            .receive(on: RunLoop.main)
            .sink { [weak self] indexPath in
                guard let indexPath else {
                    return
                }
                self?.savedAppDetailTableView.deleteRows(at: [indexPath], with: .automatic)
            }.store(in: &cancellables)
        
        output.presentAppFolderEditAlert
            .receive(on: RunLoop.main)
            .sink{ [weak self] (alert, appFolder) in
                var alertViewModel = alert
                alertViewModel.alertActions?[0].handler = { _ in
                    self?.presentAppFolderEditView(appFolder: appFolder)
                }
                alertViewModel.alertActions?[1].handler = { _ in
                    self?.deleteActionDidTapped.send(())
                }
                self?.presentAlert(alertViewModel)
            }.store(in: &cancellables)
        
        output.presentAppFolderDeleteAlert
            .receive(on: RunLoop.main)
            .sink { [weak self] alertViewModel in
                self?.presentAlert(alertViewModel)
            }.store(in: &cancellables)
        
        output.navigateToAppFolderListView
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &cancellables)
        
        output.errorAlertViewModel
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.presentAlert($0)
            }.store(in: &cancellables)
        
        output.headerViewModel
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.headerView.bind($0)
            }.store(in: &cancellables)
    }
    
    @objc
    private func editBarButtonDidTapped() {
        editButtonDidTapped.send(())
    }
    
    private func pushAppDetailView(of appDetail: AppDetail?) {
        coordinator?.pushAppDetailView(of: appDetail)
    }
    
    private func presentAppFolderEditView(appFolder: AppFolder) {
        let appFolderEditVC = coordinator?.presentAppFolderEditView(
            appFolder: appFolder)
        appFolderEditVC?.presenter = self
    }
    
    private func navigateToSearchView() {
        coordinator?.popToSearchView()
    }
    
}

extension AppFolderDetailViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
            savedAppDetailTableView.deselectRow(at: indexPath, animated: true)
            cellDidSelectedAt.send(indexPath)
        }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: Text.delete
        ) {  [unowned self] _, _, _ in
            cellWillDeletedAt.send(indexPath)
            viewWillRefresh.send(())
        }
        
        let actionConfigurations = UISwipeActionsConfiguration(
            actions: [deleteAction])
        return actionConfigurations
    }
    
}

extension AppFolderDetailViewController: AppFoldrDetailViewPresenter {
    
    func viewWillAppear() {
        viewWillRefresh.send(())
    }
    
}

private enum Design {
    
    static let backgroundColor: UIColor = Color.favoriteLavender
    static let navigationBarTintColor = Color.blueGreen
    
}
