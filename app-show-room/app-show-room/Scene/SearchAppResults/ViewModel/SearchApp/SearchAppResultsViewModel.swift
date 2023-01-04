//
//  SearchAppResultsViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/20.
//

import Foundation

protocol SearchAppResultsViewModelInput {
    
    func didSelectAppResultsTableViewCell(_ row: Int) -> AppDetail
    
}

protocol SearchAppResultsViewModelOutput {
    
    func numberOfSearchAppCell() -> Int
    func searchAppCellModel(indexPath: IndexPath) -> SearchAppTableViewCellModel
    
}

struct SearchAppResultsViewModel {
    
    private let searchAppDetails: [AppDetail]
    private let searchAppCellModel: [SearchAppTableViewCellModel]
    
    init(searchAppDetails: [AppDetail]) {
        self.searchAppDetails = searchAppDetails
        self.searchAppCellModel = searchAppDetails.map{
            SearchAppTableViewCellModel(app: $0)}
    }
    
}

// MARK: - SeachAppResultsViewModelInput

extension SearchAppResultsViewModel: SearchAppResultsViewModelInput {
    
    func didSelectAppResultsTableViewCell(_ row: Int) -> AppDetail {
        return searchAppDetails[row]
    }
    
}

// MARK: - SeachAppResultsViewModelOutput

extension SearchAppResultsViewModel: SearchAppResultsViewModelOutput {
    
    func numberOfSearchAppCell() -> Int {
        return searchAppCellModel.count
    }
    
    
    func searchAppCellModel(
        indexPath: IndexPath)
    -> SearchAppTableViewCellModel
    {
        return searchAppCellModel[indexPath.row]
    }
    
}
