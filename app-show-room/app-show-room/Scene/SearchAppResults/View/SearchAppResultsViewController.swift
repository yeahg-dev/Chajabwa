//
//  SearchAppResultsViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/20.
//

import UIKit

protocol SearchAppResultsViewDelegate: AnyObject {
    
    func didSelectRowOf(_ appDetail: AppDetail)
    
}

enum SearchResults {
    
    case recentSearchKeywords
    case apps
    
}

private enum SearhKeywordSaving {
    
    case active
    case deactive
    
}

final class SearchAppResultsViewController: UITableViewController {
    
    weak var delegate: SearchAppResultsViewDelegate?
    
    private let searchKeywordTableHeaderView = SearchKeywordTableHeaderView()
    private let searchKeywordTableFooterView = SearchKeywordTableFooterView()
    
    private var searchAppResultsViewModel: SearchAppResultsViewModel
    private var recentSearchKeywordViewModel = RecentSearchKeywordsViewModel()!
    private let searchKeywordTableHeaderViewModel = SearchKeywordTableHeaderViewModel()
    private let searchKeywordTableFooterViewModel = SearchKeywordTableFooterViewModel()
    
    private var results: SearchResults = .recentSearchKeywords
    private var searchKeywordSaving: SearhKeywordSaving {
        return recentSearchKeywordViewModel.isActivateSavingButton ? .active : .deactive
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: SearchAppResultsViewModel) {
        self.searchAppResultsViewModel = viewModel
        super.init(style: .plain)
    }
    
    func refreshSearchKeywordTableView() {
        recentSearchKeywordViewModel.fetchLatestData {
            DispatchQueue.main.async {
                self.showRecentSearchKeywordTableView()
            }
        }
    }
    
    func updateTableView(of results: SearchResults) {
        switch results {
        case .recentSearchKeywords:
            self.results = .recentSearchKeywords
            showRecentSearchKeywordTableView()
        case .apps:
            self.results = .apps
            tableView.tableFooterView?.isHidden = false
            tableView.tableHeaderView?.isHidden = false
        }
    }
    
    private func showRecentSearchKeywordTableView() {
        tableView.tableHeaderView?.isHidden = false
        switch searchKeywordSaving {
        case .active:
            tableView.tableFooterView?.isHidden = false
        case .deactive:
            tableView.tableFooterView?.isHidden = true
        }
        tableView.reloadData()
    }
    
    func showSearchAppResults(viewModel: SearchAppResultsViewModel) {
        recentSearchKeywordViewModel.keywordDidSearched()
        updateTableView(of: .apps)
        self.searchAppResultsViewModel = viewModel
        tableView.reloadData()
    }
    
    func scrollToTop() {
        guard tableView.numberOfRows(inSection: 0) != 0 else {
            return
        }
        
        tableView.scrollToRow(
            at: IndexPath(row: 0, section: 0),
            at: .top,
            animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureView()
        configureTableView()
    }
    
    private func configureView() {
        view.backgroundColor = Design.backgroundColor
        updateTableView(of: .recentSearchKeywords)
    }
    
    private func configureTableView() {
        tableView.register(cellWithClass: SearchAppTableViewCell.self)
        tableView.register(cellWithClass: RecentSearchKeywordTableViewCell.self)
        searchKeywordTableHeaderView.frame = .init(
            origin: .zero,
            size: .init(width: view.bounds.width, height: 75))
        tableView.tableHeaderView = searchKeywordTableHeaderView
        searchKeywordTableHeaderView.recentKeywordSavingUpdater = self
        searchKeywordTableHeaderView.bind(searchKeywordTableHeaderViewModel)
        searchKeywordTableFooterView.frame = .init(
            origin: .zero,
            size: .init(width: view.bounds.width, height: 60))
        tableView.tableFooterView = searchKeywordTableFooterView
        searchKeywordTableFooterView.searchKeywordTableViewUpdater = self
        searchKeywordTableFooterView.bind(searchKeywordTableFooterViewModel)
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
    -> Int
    {
        switch results {
        case .recentSearchKeywords:
            return recentSearchKeywordViewModel.numberOfSearchKeywordCell
        case .apps:
            return searchAppResultsViewModel.numberOfSearchAppCell()
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        switch results {
        case .recentSearchKeywords:
            let cell = tableView.dequeueReusableCell(
                withClass: RecentSearchKeywordTableViewCell.self,
                for: indexPath)
            // TODO: - 파라미터 컨벤션 통일
            let cellModel = recentSearchKeywordViewModel.searchKeywordCellModel(
                at: indexPath)
            cell.bind(viewModel: cellModel)
            return cell
        case .apps:
            let cell = tableView.dequeueReusableCell(
                withClass: SearchAppTableViewCell.self,
                for: indexPath)
            let cellModel = searchAppResultsViewModel.searchAppCellModel(
                indexPath: indexPath)
            cell.bind(cellModel)
            return cell
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
            switch results {
            case .recentSearchKeywords:
                tableView.deselectRow(at: indexPath, animated: true)
                Task {
                    let result = await recentSearchKeywordViewModel.cellDidSelected(at: indexPath)
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
                            showSearchAppResults(
                                viewModel: searchAppResultsViewModel)
                            scrollToTop()
                        }
                    case .failure(let alertViewModel):
                        self.presentAlert(alertViewModel)
                    }
                    refreshSearchKeywordTableView()
                }
            case .apps:
                tableView.deselectRow(at: indexPath, animated: true)
                let appDetail = searchAppResultsViewModel.didSelectAppResultsTableViewCell(
                    indexPath.row)
                delegate?.didSelectRowOf(appDetail)
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
    
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration?
    {
        guard results == .recentSearchKeywords else {
            return nil
        }
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "삭제"
        ) {  [weak self] _, _, _ in
            self?.recentSearchKeywordViewModel.cellDidDeleted(
                at: indexPath,
                completion: {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                })
        }
        
        let actionConfigurations = UISwipeActionsConfiguration(
            actions: [deleteAction])
        return actionConfigurations
    }
    
}

extension SearchAppResultsViewController: SearchKeywordSavingUpdater {
    
    func didChangedVaule(to isOn: Bool) {
        refreshSearchKeywordTableView()
    }
    
}

extension SearchAppResultsViewController: SearchKeywordTableViewUpdater {
    
    func allSearchKeywordDidDeleted() {
        refreshSearchKeywordTableView()
    }
    
}

private enum Design {
    
    static let backgroundColor: UIColor = .systemBackground
    
}

