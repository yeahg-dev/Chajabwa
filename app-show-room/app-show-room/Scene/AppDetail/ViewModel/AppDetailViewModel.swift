//
//  AppDetailViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import Foundation

protocol AppDetailViewModelOutput {
    
    func numberOfSection() -> Int
    func numberOfRows(in section: Int) -> Int
    func cellType(at indexPath: IndexPath) -> BaseAppDetailTableViewCell
    func cellModel(at indexPath: IndexPath) -> BaseAppDetailTableViewCellModel
    func cellHeight(at indexPath: IndexPath) -> Double
    func sectionHeaderTitle(for section: Int) -> String?

}

struct AppDetailViewModel {
    
}
