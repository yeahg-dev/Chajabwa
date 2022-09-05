//
//  SearchViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/12.
//

import UIKit

final class SearchViewController: UIViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    private let appSearchViewModel: AppSearchViewModel
    
    init(appSearchViewModel: AppSearchViewModel) {
        self.appSearchViewModel = appSearchViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationController()
        configureSearchController()
        bind(appSearchViewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationController() {
        navigationItem.searchController = self.searchController
        navigationItem.title = "Search App"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSearchController() {
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.delegate = self
    }
    
    private func bind(_ viewModel: AppSearchViewModel) {
        viewModel.searchBarPlaceholder.observe(on: self) { [weak self] placeholder in
            self?.searchController.searchBar.placeholder = placeholder
        }
        viewModel.searchResult.observe(on: self) { [weak self] appDetail in
            guard let appDetail = appDetail else {
                return
            }

            let appDetailViewController = AppDetailViewController(appDetailViewModel: AppDetailViewModel(app: appDetail))
            self?.navigationController?.pushViewController(appDetailViewController, animated: true)
        }
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

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let input = searchController.searchBar.text else {
            return
        }
        
        appSearchViewModel.didTappedSearch(with: input)
    }
}
