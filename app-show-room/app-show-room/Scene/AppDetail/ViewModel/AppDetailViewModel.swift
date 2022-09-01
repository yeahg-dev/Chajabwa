//
//  AppDetailViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import UIKit

protocol AppDetailViewModelOutput {
    

}

struct AppDetailViewModel {
    
    enum Section: Int, CaseIterable {
        
        case summary
        case screenshot
        case descritption
        case information
    
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
                let truncatedDescription = app.description
                let description = Description(text: truncatedDescription)
                return [Item.description(description)]
            case .information:
                let provider = Information(
                    category: Text.provider.value,
                    value: app.provider)
                let size = Information(
                    category: Text.fileSize.value,
                    value: app.fileSize?.formattedByte)
                let genre = Information(
                    category: Text.genre.value,
                    value: app.primaryGenreName)
                let contentAdvisoryRating = Information(
                    category: Text.contentAdvisoryRating.value,
                    value: app.contentAdvisoryRating)
                let minimumOSVersion = Information(
                    category: Text.minimumOSVersion.value,
                    value: app.minimumOSVersion)
                let sellerURL = Information(
                    category: Text.developerWebsite.value,
                    value: app.sellerURL)
                let informations = [provider, size, genre, contentAdvisoryRating, minimumOSVersion, sellerURL]
                return informations.map { Item.information($0) }
            }
        }
        
    }
    
    private let app: AppDetail
    let sections: [Section] = Section.allCases
    
    var screenshotURLs: [String]? {
        return app.screenShotURLs
    }
    
    var iconImageURL: String? {
        return app.iconImageURL
    }
    
    func description(isTruncated: Bool ) -> Item {
        if isTruncated {
            let fullDescription = Description(text: app.description, isTrucated: isTruncated)
            return Item.description(fullDescription)
        } else {
            let fullDescription = Description(text: app.description, isTrucated: isTruncated)
            return Item.description(fullDescription)
        }
    }
    
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
        case .information:
            return 6
        }
    }
    
}

extension AppDetailViewModel: AppDetailViewModelOutput {
    
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
        case information(Information)
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
        var isTrucated: Bool = true
        var buttonTitle: String {
            return isTrucated ? Text.moreDetails.value : Text.preview.value
        }
    }
    
    struct Information: Hashable {
        let category: String
        let value: String?
    }
    
}
