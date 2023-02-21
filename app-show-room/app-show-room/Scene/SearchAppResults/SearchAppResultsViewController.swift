//
//  SearchAppResultsViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/20.
//

import UIKit

// MARK: - SearchAppResultsDelegate

protocol SearchAppResultsDelegate: AnyObject {
    
    func pushAppDetailView(_ appDetail: AppDetail)
    
    func pushAppFolderSelectView(of appUnit: AppUnit, iconImageURL: String?)
    
    func resignSearchBarFirstResponder()
    
}

// MARK: - SearhKeywordSaving

private enum SearhKeywordSaving {
    
    case active
    case deactive
    
}

// MARK: - SearchAppResultsViewController

final class SearchAppResultsViewController: UITableViewController {
    
    var showAppResults: Bool = false {
        willSet(isTableHeaderFooterHidden) {
            if isTableHeaderFooterHidden {
                tableView.tableHeaderView = nil
                tableView.tableFooterView = nil
                view.layoutIfNeeded()
            } else {
                tableView.tableHeaderView = searchKeywordTableHeaderView
                tableView.tableFooterView = searchKeywordTableFooterView
                view.layoutIfNeeded()
            }
        }
    }
    weak var delegate: SearchAppResultsDelegate?
    
    private lazy var searchKeywordTableHeaderView = SearchKeywordTableHeaderView(
        frame: .init(
            origin: .zero,
            size: .init(width: view.bounds.width, height: Design.searchKeywordHedaerViewHeight)))
    private lazy var searchKeywordTableFooterView = SearchKeywordTableFooterView(
        frame: .init(
            origin: .zero,
            size: .init(width: view.bounds.width, height: Design.searchKeywordFooterViewHeight)))
    
    private let searchKeywordTableHeaderViewModel = SearchKeywordTableHeaderViewModel()
    private let searchKeywordTableFooterViewModel = SearchKeywordTableFooterViewModel()
    private var searchAppResultsViewModel: SearchAppResultsTableViewModel
    private var recentSearchKeywordViewModel = {
        let searchKeywordRepository = RealmSearchKeywordRepository()
        let viewModel = RecentSearchKeywordTableViewModel(
            recentSearchKeywordUsecase: .init(searchKeywordRepository: searchKeywordRepository),
            appSearchUsecase: .init(searchKeywordRepository: searchKeywordRepository))
        return viewModel
    }()
    
    private var searchKeywordSaving: SearhKeywordSaving {
        return recentSearchKeywordViewModel.isActivateSavingButton ? .active : .deactive
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: SearchAppResultsTableViewModel) {
        self.searchAppResultsViewModel = viewModel 
        super.init(style: .plain)
    }
    
    func showRecentSearchKeywordTableView() {
        showAppResults = false
        tableView.dataSource = recentSearchKeywordViewModel
        tableView.delegate = recentSearchKeywordViewModel
        refreshSearchKeywordTableView()
    }
    
    func refreshSearchKeywordTableView() {
        scrollToTop()
        Task {
            await recentSearchKeywordViewModel.fetchLatestData()
            await MainActor.run(body: {
                self.tableView.tableHeaderView?.isHidden = false
                switch self.searchKeywordSaving {
                case .active:
                    self.tableView.tableFooterView?.isHidden = false
                case .deactive:
                    self.tableView.tableFooterView?.isHidden = true
                }
                self.tableView.reloadData()
            })
        }
    }
    
    func scrollToTop() {
        guard let searchBarHeight = navigationItem.searchController?.searchBar.bounds.height else {
            return
        }
        tableView.bounds.origin.y = searchBarHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTableView()
    }
    
    private func configureView() {
        view.backgroundColor = Design.backgroundColor
    }
    
    private func configureTableView() {
        tableView.register(cellWithClass: SearchAppTableViewCell.self)
        tableView.register(cellWithClass: RecentSearchKeywordTableViewCell.self)
        
        searchAppResultsViewModel.appDetailViewPresenter = self
        recentSearchKeywordViewModel.appDetailViewPresenter = self
        recentSearchKeywordViewModel.searchAppResultTableViewUpdater = self
 
        tableView.tableHeaderView = searchKeywordTableHeaderView
        searchKeywordTableHeaderView.delegate = self
        searchKeywordTableHeaderView.bind(searchKeywordTableHeaderViewModel)
        
        tableView.tableFooterView = searchKeywordTableFooterView
        searchKeywordTableFooterView.searchKeywordTableViewUpdater = self
        searchKeywordTableFooterView.bind(searchKeywordTableFooterViewModel)
    }
    
}

// MARK: - SearchResultsTableViewCellDelegate

extension SearchAppResultsViewController: SearchAppResultsTableViewCellDelegate {
    
    func pushAppFolderSelectView(of appUnit: AppUnit, iconImageURL: String?) {
        delegate?.pushAppFolderSelectView(of: appUnit, iconImageURL: iconImageURL)
    }
    
    func pushAppDetailView(of app: AppDetail) {
        delegate?.pushAppDetailView(app)
    }
    
}

// MARK: - SearchAppResultTableViewUpdater

extension SearchAppResultsViewController: SearchAppResultTableViewUpdater {
    
    func updateSearchAppResultTableView(with searchApps: [AppDetail]) {
        showAppResults = true
        scrollToTop()
        delegate?.resignSearchBarFirstResponder()
        searchAppResultsViewModel = SearchAppResultsTableViewModel(
            searchAppDetails: searchApps)
        searchAppResultsViewModel.appDetailViewPresenter = self
        tableView.dataSource = searchAppResultsViewModel
        tableView.delegate = searchAppResultsViewModel
        tableView.reloadData()
    }
    
}

// MARK: - SearchKeywordTableHeaderViewDelegate

extension SearchAppResultsViewController: SearchKeywordTableHeaderViewDelegate {
    
    func didChangedVaule(to isOn: Bool) {
        refreshSearchKeywordTableView()
    }
    
}

// MARK: - SearchKeywordTableFooterViewDelegate

extension SearchAppResultsViewController: SearchKeywordTableFooterViewDelegate {
    
    func allSearchKeywordDidDeleted() {
        refreshSearchKeywordTableView()
    }
    
}

// MARK: - Design

private enum Design {
    
    static let backgroundColor: UIColor = Color.lightSkyBlue
    
    static let searchKeywordHedaerViewHeight: CGFloat =  75
    static let searchKeywordFooterViewHeight: CGFloat = 60
    
}

