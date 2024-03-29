//
//  SearchViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/12.
//

import UIKit

final class SearchViewController: UIViewController {
    
    var coordinator: SearchCoordinator?

    // MARK: - UIComponents
    
    private let searchAppResultsController = SearchAppResultsViewController(
        viewModel: SearchAppResultsTableViewModel(searchAppDetails: []))
    
    private lazy var searchController = UISearchController(
        searchResultsController: searchAppResultsController)
    
    private lazy var folderButton: UIButton = {
        let button = UIButton()
        button.setImage(
            Images.Icon.folder.image,
            for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(
            self,
            action: #selector(pushAppFolderListView),
            for: .touchDown)
        return button
    }()
    
    private let searchBackgroundView = SearchBackgroundView()
    
    private var prepareProgressAlertViewController: UIAlertController?
    
    // MARK: - ViewModel
    
    private let viewModel: SearchViewModel
    
    // MARK: - Initializer
    
    init(searchViewModel: SearchViewModel) {
        self.viewModel = searchViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationItem()
        configureSearchController()
        configureIntialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    
    }
    
    private func configureNavigationItem() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : Design.navigationBarLargeTitleTextColor]
        navigationItem.title = viewModel.navigationItemTitle
        let rightBarButtonItem = UIBarButtonItem(customView: folderButton)
        navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
        NSLayoutConstraint.activate([
            folderButton.widthAnchor.constraint(equalToConstant: Design.appFolderButtonWidth),
            folderButton.heightAnchor.constraint(equalToConstant: Design.appFolderButtonWidth)
        ])
    }
    
    // MARK: - Private Methods
    
    private func configureView() {
        view = searchBackgroundView
        searchBackgroundView.delegate = self
        navigationItem.searchController = self.searchController
        searchController.searchBar.searchTextField.backgroundColor = Design.searchBarTextFieldBackgroundColor
        searchController.searchBar.searchTextField.textColor = Design.searchBarTextFieldTextColor
        searchController.searchBar.tintColor = Design.searchBarTintColor
    }
    
    private func configureSearchController() {
        searchController.searchBar.delegate = self
        searchAppResultsController.delegate = self
    }
    
    private func configureIntialState() {
        searchController.searchBar.placeholder = viewModel.searchBarPlaceholder
        refreshView()
    }
    
    private func refreshView() {
        searchBackgroundView.bindCountry(
            flag: viewModel.countryFlag,
            name: viewModel.countryName)
        searchBackgroundView.bindPlatform(viewModel.platformType)
    }
    
    @objc
    private func pushAppFolderListView() {
        coordinator?.pushAppFolderListView()
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.showsSearchResultsController = true
        searchAppResultsController.showRecentSearchKeywordTableView()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let input = searchController.searchBar.text else {
            return
        }
        Task {
            let result = await viewModel.didTappedSearch(with: input)
            searchAppResultsController.refreshSearchKeywordTableView()
            switch result {
            case .success(let appDetails):
                if appDetails.count == 1 {
                    coordinator?.pushAppDetailView(appDetails.first!)
                } else {
                    searchAppResultsController.updateSearchAppResultTableView(with: appDetails)
                }
            case .failure(let alertViewModel):
                self.presentAlert(alertViewModel)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchAppResultsController.showAppResults = false
        searchController.showsSearchResultsController = false
    }
    
}

// MARK: - SearchAppResultsViewDelegate

extension SearchViewController: SearchAppResultsDelegate {
    
    func pushAppDetailView(_ appDetail: AppDetail) {
        coordinator?.pushAppDetailView(appDetail)
    }
    
    func pushAppFolderSelectView(of appUnit: AppUnit, iconImageURL: String?) {
        coordinator?.pushAppFolderSelectView(of: appUnit, iconImageURL: iconImageURL)
    }
    
    func resignSearchBarFirstResponder() {
        searchController.searchBar.resignFirstResponder()
    }
    
}

// MARK: - SearchBackgroundViewPresentaionDelegate

extension SearchViewController: SearchBackgroundViewDelegate {
    
    func presentSettingView(view: SettingViewController.Type) {
        let settingView = coordinator?.presentSettingView()
        settingView?.settingViewdelegate = self
    }
    
}

// MARK: - SettingViewDelegate

extension SearchViewController: SettingViewPresenter {
    
    func didSettingChanged() {
        refreshView()
    }
    
}

private enum Design {
    
    static let appFolderButtonWidth: CGFloat = 30
    
    static let navigationBarLargeTitleTextColor = UIColor.white
    static let searchBarTextFieldBackgroundColor = Colors.skyBlue.color
    static let searchBarTextFieldTextColor = UIColor.white
    static let searchBarTintColor: UIColor = Colors.blueGreen.color
}
