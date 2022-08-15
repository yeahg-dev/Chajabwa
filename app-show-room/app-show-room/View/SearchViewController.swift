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
        self.configureView()
        self.configureNavigationController()
        self.configureSearchController()
        self.bind(appSearchViewModel)
    }
    
    private func configureView() {
        self.view.backgroundColor = .white
    }
    
    private func configureNavigationController() {
        self.navigationItem.searchController = self.searchController
        self.navigationItem.title = "Search App"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSearchController() {
        self.searchController.hidesNavigationBarDuringPresentation = true
        self.searchController.searchBar.delegate = self
    }
    
    private func bind(_ viewModel: AppSearchViewModel) {
        viewModel.searchBarPlaceholder.observe(on: self) { placeholder in
            self.searchController.searchBar.placeholder = placeholder
        }
        viewModel.searchResult.observe(on: self) { appDetail in
            print(appDetail?.sellerName as Any)
        }
        viewModel.searchFailureAlert.observe(on: self) { alertText in
            guard let alertText = alertText else {
                return
            }
            self.presentAlert(alertText)
        }
    }
    
    private func presentAlert(_ alertText: AlertText) {
        let alertController = UIAlertController(
            title: alertText.title,
            message: alertText.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: alertText.alertAction,
            style: .default)
        alertController.addAction(action)
        
        self.present(alertController, animated: false)
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let input = self.searchController.searchBar.text else {
            return
        }
        self.appSearchViewModel.didTappedSearch(with: input)
    }
}
