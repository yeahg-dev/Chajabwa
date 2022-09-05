//
//  AppDetailViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import UIKit

struct AppDetailViewModel {
    
    enum Section: Int, CaseIterable {
        case signBoard
        case summary
        case releaseNote
        case screenshot
        case descritption
        case information
        
        var title: String? {
            switch self {
            case .signBoard:
                return nil
            case .summary:
                return nil
            case .releaseNote:
                return "새로운 기능"
            case .screenshot:
                return "미리보기"
            case .descritption:
                return nil
            case .information:
                return "정보"
            }
        }
    }
    
    private let app: AppDetail
    let sections: [Section] = Section.allCases
    
    init(app: AppDetail) {
        self.app = app
    }
   
    var screenshotURLs: [String]? {
        return app.screenShotURLs
    }
    
    var iconImageURL: String? {
        return app.iconImageURL
    }
    
    var summaryCollectionViewCellCount: Int {
        return summaryItems.count
    }
    
    var linkInformationsIndexPaths: [IndexPath] {
        var indexPaths = [IndexPath]()
        let totalInforationItem = textInformations.count + linkInformations.count
        for index in textInformations.count ..< totalInforationItem {
            let hyperlinkInformationIndexPath = IndexPath(row: index, section: Section.information.rawValue)
            indexPaths.append(hyperlinkInformationIndexPath)
        }
        return indexPaths
    }
    
    func releaseNote(isTruncated: Bool) -> Item {
        let releaseNote = ReleaseNote(
            version: app.version,
            currentVersionReleaseDate: app.currentVersionReleaseDate,
            description: app.releaseDescription,
            isTruncated: isTruncated)
        return Item.releaseNote(releaseNote)
    }
    
    func description(isTruncated: Bool) -> Item {
        if isTruncated {
            let fullDescription = Description(text: app.description, isTrucated: isTruncated)
            return Item.description(fullDescription)
        } else {
            let fullDescription = Description(text: app.description, isTrucated: isTruncated)
            return Item.description(fullDescription)
        }
    }
    
    func cellItems(at section: Int) -> [Item] {
        guard let section = Section(rawValue: section) else {
            return []
        }
        
        return cellItems(at: section)
    }
    
    private func cellItems(at section: Section) -> [Item] {
        switch section {
        case .signBoard:
            let info = AppSignBoard(
                name: app.appName,
                iconImageURL: app.iconImageURL,
                provider: app.provider,
                price: app.price)
            return [Item.signBoard(info)]
        case .summary:
            return summaryItems
        case .releaseNote:
            let releaseNote = ReleaseNote(
                version: app.version,
                currentVersionReleaseDate: app.currentVersionReleaseDate,
                description: app.releaseDescription, isTruncated: true)
            return [Item.releaseNote(releaseNote)]
        case .screenshot:
            let items = app.screenShotURLs?.map { Screenshot(url: $0) }
                .map{ Item.screenshot($0) }
            return items ?? []
        case .descritption:
            let description = Description(text: app.description)
            return [Item.description(description)]
        case .information:
           return textInformations + linkInformations
        }
    }
    
    private var summaryItems: [Item] {
        var summarys = [Summary]()
        
        if let averageUserRating = app.averageUserRating,
           let userRatingCount = app.userRatingCount {
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 1
            let averageUserRatingText = numberFormatter.string(from: averageUserRating as NSNumber)
            let averageUserRatingSummary = Summary(
                primaryText: Text.ratingCount.value(with: userRatingCount),
                secnondaryText: "일단 비움",
                symbolImage: TextSymbolView(averageUserRatingText ?? "_").image)
            summarys.append(averageUserRatingSummary)
        }
        
        if let contentAdvisoryRating = app.contentAdvisoryRating {
            let contentAdvisoryRatingSummary = Summary(
                primaryText: Text.age.value,
                secnondaryText: Text.old.value,
                symbolImage: TextSymbolView(contentAdvisoryRating).image)
            summarys.append(contentAdvisoryRatingSummary)
        }
        
        if let provider = app.provider {
            let developerImage = UIImage(systemName: "person.crop.square")
            let providerSummary = Summary(
                primaryText: Text.developer.value,
                secnondaryText: provider,
                symbolImage: developerImage)
            summarys.append(providerSummary)
        }
        
        if let genre = app.primaryGenreName {
            let genreImage = AppGenre(rawValue: genre)?.symbolImage
            let genreSummary = Summary(
                primaryText: Text.genre.value,
                secnondaryText: genre,
                symbolImage: genreImage)
            summarys.append(genreSummary)
        }
        
        if let languageCodes = app.languageCodesISO2A,
           let firstLanguageCode = languageCodes.first {
            let languageSummary = Summary(
                primaryText: Text.language.value,
                secnondaryText: Text.languageCount.value(with: languageCodes.count),
                symbolImage: TextSymbolView(firstLanguageCode).image)
            summarys.append(languageSummary)
        }
        
        return summarys.map { Item.summary($0) }
    }
  
    private var textInformations: [Item] {
        var inforamtions = [Information]()
        
        if let provider = app.provider {
            inforamtions.append(Information(
                category: Text.provider.value,
                value: provider,
                image: nil))
        }
        
        if let fileSize = app.fileSize {
            inforamtions.append(Information(
                category: Text.fileSize.value,
                value: fileSize.formattedByte,
                image: nil))
        }
        
        if let genre = app.primaryGenreName {
            inforamtions.append(Information(
                category: Text.genre.value,
                value: genre,
                image: nil))
        }
        
        if let contentAdvisoryRating = app.contentAdvisoryRating {
            inforamtions.append(Information(
                category: Text.contentAdvisoryRating.value,
                value: contentAdvisoryRating,
                image: nil))
        }
        
        if let minimumOSVersion = app.minimumOSVersion {
            inforamtions.append(Information(
                category: Text.minimumOSVersion.value,
                value: minimumOSVersion,
                image: nil))
        }
        
        return inforamtions.map { Item.information($0) }
    }
    
    private var linkInformations: [Item] {
        var inforamtions = [Information]()
        
        if let sellerURL = app.sellerURL {
            inforamtions.append(Information(
                category: Text.developerWebsite.value,
                value: sellerURL,
                image: UIImage(systemName: "safari.fill")))
        }

        return inforamtions.map { Item.information($0) }
    }
 
}

extension AppDetailViewModel {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    enum Item: Hashable {
        case signBoard(AppSignBoard)
        case summary(Summary)
        case releaseNote(ReleaseNote)
        case screenshot(Screenshot)
        case description(Description)
        case information(Information)
    }
    
    struct AppSignBoard: Hashable {
        let name: String?
        let iconImageURL: String?
        let provider: String?
        let price: String?
    }
    
    struct Summary: Hashable {
        let primaryText: String?
        let secnondaryText: String?
        let symbolImage: UIImage?
    }
    
    struct ReleaseNote: Hashable {
        private let versionValue: String?
        private let currentVersionReleaseDateValue: String?
        private let fullDescription: String?
        var isTrucated: Bool
        
        init(version: String?, currentVersionReleaseDate: String?, description: String?,
             isTruncated: Bool) {
            self.versionValue = version
            self.currentVersionReleaseDateValue = currentVersionReleaseDate
            self.fullDescription = description
            self.isTrucated = isTruncated
        }

        var description: String? {
            if isTrucated {
                return previewDescription
            } else {
                return fullDescription
            }
        }
        
        private var previewDescription: String? {
            return fullDescription?.previewText
        }
        
        var version: String? {
            if let versionValue = versionValue {
                return Text.version.value + " " + versionValue
            }
            return nil
        }
        
        var currentVersionReleaseDate: String? {
            return releaseDateRepresentation(currentVersionReleaseDateValue)
        }
        
        var buttonTitle: String? {
            if fullDescription ==  previewDescription {
                return nil
            } else {
                return isTrucated ? Text.moreDetails.value : Text.preview.value
            }
        }
        
        private func releaseDateRepresentation(_ string: String?) -> String? {
            guard let string = string,
                  let releaseDate = ISO8601DateFormatter().date(from: string) else {
                return nil
            }
   
            return AppDetailViewModel.dateFormatter.string(from: releaseDate)
        }
        
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
        let category: String?
        let value: String?
        let image: UIImage?
    }
    
}
