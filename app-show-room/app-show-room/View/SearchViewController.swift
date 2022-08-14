//
//  SearchViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/12.
//

import UIKit

class SearchViewController: UIViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.configureNavigationController()
        self.configureSearchController()
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
        self.searchController.searchBar.placeholder = "ID를 입력해주세요"
        self.searchController.hidesNavigationBarDuringPresentation = false
    }


}

