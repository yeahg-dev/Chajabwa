//
//  SearchAppResultsViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/20.
//

import UIKit

protocol SearchAppResultsViewDelegate: AnyObject {
    
    func pushAppDetailView(_ appDetail: AppDetail)
    
    func pushAppFolderSelectView(of appUnit: AppUnit, iconImageURL: String?)
    
}

private enum SearhKeywordSaving {
    
    case active
    case deactive
    
}

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
    weak var delegate: SearchAppResultsViewDelegate?
    
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
        searchKeywordTableHeaderView.recentKeywordSavingUpdater = self
        searchKeywordTableHeaderView.bind(searchKeywordTableHeaderViewModel)
        
        tableView.tableFooterView = searchKeywordTableFooterView
        searchKeywordTableFooterView.searchKeywordTableViewUpdater = self
        searchKeywordTableFooterView.bind(searchKeywordTableFooterViewModel)
    }
    
}

// MARK: - AppDetailViewPresenter

extension SearchAppResultsViewController: AppDetailViewPresenter {
    
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
        searchAppResultsViewModel = SearchAppResultsTableViewModel(
            searchAppDetails: searchApps)
        searchAppResultsViewModel.appDetailViewPresenter = self
        tableView.dataSource = searchAppResultsViewModel
        tableView.delegate = searchAppResultsViewModel
        tableView.reloadData()
    }
    
}

// MARK: - SearchKeywordSavingUpdater

extension SearchAppResultsViewController: SearchKeywordSavingUpdater {
    
    func didChangedVaule(to isOn: Bool) {
        refreshSearchKeywordTableView()
    }
    
}

// MARK: - SearchKeywordTableViewUpdater

extension SearchAppResultsViewController: SearchKeywordTableViewUpdater {
    
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

