//
//  AppDetailViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import UIKit

protocol AppDetailViewModelOutput {
    
    func numberOfSection() -> Int
    
    func numberOfRows(in section: Int) -> Int
    
    func cellType(at indexPath: IndexPath) -> BaseCollectionViewCell.Type
    
    func cellModel(at indexPath: IndexPath) -> AppDetailItem

}

struct AppDetailViewModel {
    
    enum Section: Int, CaseIterable {
        
        case summary
        case screenshot
        case descritption
        
        var cellType: BaseCollectionViewCell.Type {
            switch self {
            case .summary:
                return AppDetailSummaryCollectionViewCell.self
            case .screenshot:
                return AppDetailScreenshotCollectionViewCell.self
            case .descritption:
                return AppDetailDescriptionCollectionViewCell.self
            }
        }
    
        func cellItem(app: AppDetail) -> [Item] {
            switch self {
            case .summary:
                let info = Info(
                    name: app.appName,
                    iconImageURL: app.iconImageURL,
                    provider: app.provider,
                    price: app.price)
                return [Item.summary(info)]
            case .screenshot:
                let items = app.screenShotURLs?.map { Screenshot(url: $0) }
                                               .map{ Item.screenshot($0) }
                return items!
            case .descritption:
                let description = Description(text: app.description)
                return [Item.description(description)]
            }
        }
        
    }
    
    private let app: AppDetail
    let sections: [Section] = Section.allCases
    
    init(app: AppDetail) {
        self.app = app
    }
    
    private func numberOfRows(in section: Section) -> Int {
        switch section {
        case .summary:
            return 1
        case .screenshot:
            return 1
        case .descritption:
            return 1
        }
    }
    
}

extension AppDetailViewModel: AppDetailViewModelOutput {
    
    func numberOfSection() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        let section = sections[section]
        return numberOfRows(in: section)
    }
    
    func cellType(at indexPath: IndexPath) -> BaseCollectionViewCell.Type {
        let section = indexPath.section
        return sections[section].cellType
    }
    
    func cellModel(at indexPath: IndexPath) -> AppDetailItem {
        return AppDetailItem(
            id: app.id,
            name: app.appName,
            iconImageURL: app.iconImageURL,
            provider: app.provider,
            price: app.price,
            screenshotURLs: app.screenShotURLs,
            description: app.description)
    }
    
    func cellItems(at section: Int) -> [Item] {
        // TODO: - 옵셔널 오류 핸들링
        return (Section(rawValue: section)?.cellItem(app: app))!
    }

}

extension AppDetailViewModel {
    
    enum Item: Hashable {
        case summary(Info)
        case screenshot(Screenshot)
        case description(Description)
    }
    
    struct Info: Hashable {
        let name: String?
        let iconImageURL: String?
        let provider: String?
        let price: String?
    }
    
    struct Screenshot: Hashable {
        let url: String
    }
    
    struct Description: Hashable {
        let text: String?
    }
    
}
