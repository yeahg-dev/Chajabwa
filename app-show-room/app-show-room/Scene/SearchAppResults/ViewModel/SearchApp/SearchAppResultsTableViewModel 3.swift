//
//  SearchAppResultsTableViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/20.
//

import UIKit

protocol AppDetailViewPresenter: AnyObject {
    
    func pushAppDetailView(of app: AppDetail)
    
}

final class SearchAppResultsTableViewModel: NSObject {
    
    weak var appDetailViewPresenter: AppDetailViewPresenter?
    
    private let searchAppDetails: [AppDetail]
    private let searchAppCellModel: [SearchAppTableViewCellModel]
    
    init(searchAppDetails: [AppDetail]) {
        self.searchAppDetails = searchAppDetails
        self.searchAppCellModel = searchAppDetails.map{
            SearchAppTableViewCellModel(app: $0)}
    }
    
}

// MARK: - UITableViewDataSource

extension SearchAppResultsTableViewModel: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
    -> Int
    {
        return searchAppCellModel.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withClass: SearchAppTableViewCell.self,
            for: indexPath)
        let cellModel = searchAppCellModel[indexPath.row]
        cell.bind(cellModel)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension SearchAppResultsTableViewModel: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let appDetail = searchAppDetails[indexPath.row]
            appDetailViewPresenter?.pushAppDetailView(of: appDetail)
        }
    
}
