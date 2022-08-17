//
//  AppDetailViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import UIKit

enum AppDetailContentSection: CaseIterable {
    
    case summary
    case screenshot
    case descritpion
    
    var cellType: BaseAppDetailCollectionViewCell.Type {
        switch self {
        case .summary:
            return AppDetailSummaryCollectionViewCell.self
        case .screenshot:
            return AppDetailScreenshotCollectionViewCell.self
        case .descritpion:
            return AppDetailDescriptionCollectionViewCell.self
        }
    }
    
}

protocol AppDetailViewModelOutput {
    
    func numberOfSection() -> Int
    
    func numberOfRows(in section: Int) -> Int
    
    func cellType(at indexPath: IndexPath) -> BaseAppDetailCollectionViewCell.Type
    
    func cellModel(at indexPath: IndexPath) -> BaseAppDetailCollectionViewCellModel

}

struct AppDetailViewModel {
    
    private let app: AppDetail
    let contentSections: [AppDetailContentSection] = AppDetailContentSection.allCases
    
    init(app: AppDetail) {
        self.app = app
    }
    
    func numberOfRows(in section: AppDetailContentSection) -> Int {
        switch section {
        case .summary:
            return 1
        case .screenshot:
            return 1
        case .descritpion:
            return 1
        }
    }
    
}

extension AppDetailViewModel: AppDetailViewModelOutput {
    
    func numberOfSection() -> Int {
        return contentSections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        let section = contentSections[section]
        return numberOfRows(in: section)
    }
    
    func cellType(at indexPath: IndexPath) -> BaseAppDetailCollectionViewCell.Type {
        let section = indexPath.section
        return contentSections[section].cellType
    }
    
    func cellModel(at indexPath: IndexPath) -> BaseAppDetailCollectionViewCellModel {
        return BaseAppDetailCollectionViewCellModel(app: self.app)
    }
    
//    func cellHeight(at indexPath: IndexPath) -> CGFloat? {
//        let section = indexPath.section
//        return contentSections[section].cellType.height
//    }
    
}
