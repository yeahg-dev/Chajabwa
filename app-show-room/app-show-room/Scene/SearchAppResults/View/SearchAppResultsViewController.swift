//
//  SearchAppResultsViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/20.
//

import UIKit

final class SearchAppResultsViewController: UITableViewController {
    
    private let viewModel: SearchAppResultsViewModel
    private let searchController = UISearchController(searchResultsController: nil)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: SearchAppResultsViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureView()
    }

    private func configureView() {
        view.backgroundColor = Design.backgroundColor
        navigationController?.navigationItem.searchController = searchController
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureTableView() {
        tableView.register(cellWithClass: SearchAppTableViewCell.self)
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
    -> Int
    {
        return viewModel.numberOfSearchAppCell()
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withClass: SearchAppTableViewCell.self, for: indexPath)
        let cellModel = viewModel.searchAppCellModel(indexPath: indexPath)
        cell.bind(cellModel)
        return cell
    }
    
}

private enum Design {
    
    static let backgroundColor: UIColor = .systemBackground
    
}

