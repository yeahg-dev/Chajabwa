//
//  SearchViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/12.
//

import UIKit

final class SearchViewController: UIViewController {

    // MARK: - UIComponents
    
    private let searchAppResultsController = SearchAppResultsViewController(
        viewModel: SearchAppResultsTableViewModel(searchAppDetails: []))
    
    private lazy var searchController = UISearchController(
        searchResultsController: searchAppResultsController)
    
    private let searchBackgroundView = SearchBackgroundView()

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
        configureSearchController()
        configureIntialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Private Methods
    
    private func configureView() {
        view = searchBackgroundView
        searchBackgroundView.presentationDelegate = self
        navigationItem.searchController = self.searchController
        searchController.searchBar.searchTextField.backgroundColor = Design.searchBarTextFieldBackgroundColor
        searchController.searchBar.searchTextField.textColor = Design.searchBarTextFieldTextColor
        searchController.searchBar.tintColor = Design.searchBarTintColor
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : Design.navigationBarLargeTitleTextColor]
        navigationItem.title = viewModel.navigationItemTitle
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureSearchController() {
        searchController.searchBar.delegate = self
        searchAppResultsController.delegate = self
    }
    
    private func configureIntialState() {
        searchController.searchBar.placeholder = viewModel.searchBarPlaceholder
        refreshState()
    }
    
    private func refreshState() {
        searchBackgroundView.bindCountry(
            flag: viewModel.countryFlag,
            name: viewModel.countryName)
        searchBackgroundView.bindPlatform(viewModel.platformType)
    }
 
    private func presentAlert(_ alertViewModel: AlertViewModel) {
        let alertController = UIAlertController(
            title: alertViewModel.alertController.title,
            message: alertViewModel.alertController.message,
            preferredStyle: alertViewModel.alertController.preferredStyle.value)
        if let alertActions = alertViewModel.alertActions {
            alertActions.forEach { actionViewModel in
                let action = UIAlertAction(
                    title: actionViewModel.title,
                    style: actionViewModel.style.value)
                alertController.addAction(action)
            }
        }
        
        present(alertController, animated: false)
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.showsSearchResultsController = true
        guard searchAppResultsController.showAppResults == false else {
            return
        }
        searchAppResultsController.showRecentSearchKeywordTableView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 1 {
            searchAppResultsController.showRecentSearchKeywordTableView()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let input = searchController.searchBar.text else {
            return
        }
        Task {
            let result = await viewModel.didTappedSearch(with: input)
            searchAppResultsController.refreshSearchKeywordTableView()
            switch result {
            case .success(let appDetail):
                if appDetail.count == 1 {
                    let appDetailViewController = AppDetailViewController(
                        appDetailViewModel: AppDetailViewModel(app: appDetail.first!))
                    navigationController?.pushViewController(
                        appDetailViewController,
                        animated: true)
                } else {
                    searchAppResultsController.updateSearchAppResultTableView(with: appDetail)
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

extension SearchViewController: SearchAppResultsViewDelegate {
    
    func pushAppDetailView(_ appDetail: AppDetail) {
        let appDetailViewController = AppDetailViewController(
            appDetailViewModel: AppDetailViewModel(app: appDetail))
        navigationController?.pushViewController(
            appDetailViewController,
            animated: true)
    }
    
    func pushAppFolderSelectView(of appUnit: AppUnit, iconImageURL: String?) {
     let view = AppFolderSelectViewController(
        appUnit: appUnit,
        iconImageURL: iconImageURL)
        navigationController?.pushViewController(view, animated: true)
    }
    
}

// MARK: - SearchBackgroundViewPresentaionDelegate

extension SearchViewController: SearchBackgroundViewPresentaionDelegate {
    
    func presentSettingView(view: SettingViewController.Type) {
        let settingView = view.init()
        settingView.settingViewdelegate = self
        settingView.modalPresentationStyle = .formSheet
        present(settingView, animated: true)
    }
    
}

// MARK: - SettingViewDelegate

extension SearchViewController: SettingViewDelegate {
    
    func didSettingChanged() {
        refreshState()
    }

}

private enum Design {
    
    static let navigationBarLargeTitleTextColor = UIColor.white
    static let searchBarTextFieldBackgroundColor = Color.skyBlue
    static let searchBarTextFieldTextColor = UIColor.white
    static let searchBarTintColor: UIColor = Color.blueGreen
}
