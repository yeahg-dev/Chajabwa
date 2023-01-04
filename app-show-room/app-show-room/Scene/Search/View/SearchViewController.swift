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
        viewModel: SearchAppResultsViewModel(searchAppDetails: []))
    
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
        if let alertActionViewModel = alertViewModel.alertAction {
            let action = UIAlertAction(
                title: alertActionViewModel.title,
                style: alertActionViewModel.style.value)
            alertController.addAction(action)
        }
        
        present(alertController, animated: false)
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.showsSearchResultsController = true
        searchAppResultsController.updateTableView(of: .recentSearchKeywords)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let input = searchController.searchBar.text else {
            return
        }
        Task {
            let result = await viewModel.didTappedSearch(with: input)
            switch result {
            case .success(let appDetail):
                if appDetail.count == 1 {
                    let appDetailViewController = AppDetailViewController(
                        appDetailViewModel: AppDetailViewModel(app: appDetail.first!))
                    navigationController?.pushViewController(
                        appDetailViewController,
                        animated: true)
                } else {
                    let searchAppResultsViewModel = SearchAppResultsViewModel(
                        searchAppDetails: appDetail)
                    searchAppResultsController.showSearchAppResults(
                        viewModel: searchAppResultsViewModel)
                    searchController.showsSearchResultsController = true
                    searchAppResultsController.scrollToTop()
                }
            case .failure(let alertViewModel):
                self.presentAlert(alertViewModel)
            }
            searchAppResultsController.refreshSearchKeywordTableView()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchAppResultsController.showSearchAppResults(
            viewModel: SearchAppResultsViewModel(searchAppDetails: []))
    }
    
}

// MARK: - SearchAppResultsViewDelegate

extension SearchViewController: SearchAppResultsViewDelegate {
    
    func didSelectRowOf(_ appDetail: AppDetail) {
        let appDetailViewController = AppDetailViewController(
            appDetailViewModel: AppDetailViewModel(app: appDetail))
        navigationController?.pushViewController(
            appDetailViewController,
            animated: true)
    }
    
}

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
