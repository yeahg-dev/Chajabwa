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
    
    private lazy var searchController = UISearchController(searchResultsController: searchAppResultsController)

    // MARK: - ViewModel
    
    private let searchViewModel: SearchViewModel
    
    // MARK: - Initializer
    
    init(searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
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
        bind(searchViewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Private Methods
    
    private func configureView() {
        view.backgroundColor = Design.backgroundColor
        navigationItem.searchController = self.searchController
        navigationItem.title = "Search App"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureSearchController() {
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.delegate = self
    }
    
    private func bind(_ viewModel: SearchViewModel) {
        viewModel.searchBarPlaceholder.observe(on: self) { [weak self] placeholder in
            self?.searchController.searchBar.placeholder = placeholder
        }
        
        viewModel.searchResult.observe(on: self) { [weak self] appDetail in
            guard let appDetail = appDetail else {
                return
            }
            let appDetailViewController = AppDetailViewController(
                appDetailViewModel: AppDetailViewModel(app: appDetail))
            self?.navigationController?.pushViewController(
                appDetailViewController,
                animated: true)
        }
        
        viewModel.searchResults.observe(on: self, { appDetails in
            let searchAppResultsViewModel = SearchAppResultsViewModel(
                searchAppDetails: appDetails)
            self.searchAppResultsController.showSearchAppResults(
                viewModel: searchAppResultsViewModel)
            self.searchController.showsSearchResultsController = true
        })
        
        viewModel.searchFailureAlert.observe(on: self) { [weak self] alertText in
            guard let alertText = alertText else {
                return
            }
            self?.presentAlert(alertText)
        }
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let input = searchController.searchBar.text else {
            return
        }
        
        searchViewModel.didTappedSearch(with: input)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchAppResultsController.showSearchAppResults(viewModel: SearchAppResultsViewModel(searchAppDetails: []))
    }
    
}

// MARK: - Design

private enum Design {
    
    static let backgroundColor: UIColor = .systemBackground
    
}
