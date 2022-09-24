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
                return Text.newFeature.value
            case .screenshot:
                return Text.screenshotView.value
            case .descritption:
                return nil
            case .information:
                return Text.information.value
            }
        }
    }
    
    enum SupplementaryElementKind: String {
        case titleHeaderView
        case paddingTitleHeaderView
        
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
            let previewDescription = Description(text: app.description, isTrucated: isTruncated)
            return Item.description(previewDescription)
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
            return [summary]
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
    
    private var summary: Item {
        var userRatingPrimaryText: String?
        var userRatingSymbolImage: UIImage?
        var contentAdivisoryRatingSymbolImage: UIImage?
        var providerSymbolImage = UIImage(systemName: "person.crop.square")
        var genreSymbolImage: UIImage?
        var languageSymbolImage: UIImage?
        var languageSecondaryText: String?
        
        if let averageUserRating = app.averageUserRating,
           let userRatingCount = app.userRatingCount {
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 1
            let averageUserRatingText = numberFormatter.string(from: averageUserRating as NSNumber)
            
            userRatingPrimaryText = Text.ratingCount.value(with: userRatingCount)
            userRatingSymbolImage = TextSymbolView(averageUserRatingText ?? "_").image
        }
    
        if let contentAdvisoryRating = app.contentAdvisoryRating {
            contentAdivisoryRatingSymbolImage =  TextSymbolView(contentAdvisoryRating).image
        }
      
        if let genre = app.primaryGenreName {
            genreSymbolImage = AppGenre(rawValue: genre)?.symbolImage
        }
        
        
        if let languageCodes = app.languageCodesISO2A,
           let firstLanguageCode = languageCodes.first {
            languageSymbolImage = TextSymbolView(firstLanguageCode).image
            languageSecondaryText = Text.languageCount.value(with: languageCodes.count)
        }
        
        let summary = Summary(
            userRatingPrimaryText: userRatingPrimaryText,
            userRatingSymbolImage: userRatingSymbolImage,
            userRatingSecondaryValue: app.averageUserRating,
            contentAdivisoryRatingPrimaryText: Text.age.value,
            contentAdivisoryRatingSymbolImage: contentAdivisoryRatingSymbolImage,
            contentAdivisoryRatingSecondaryText: Text.old.value,
            providerPrimaryText: Text.developer.value,
            providerSymbolImage: providerSymbolImage,
            providerSecondaryText: app.provider,
            genrePrimaryText: Text.genre.value,
            genreSymbolImage: genreSymbolImage,
            genreSecondaryText: app.primaryGenreName,
            languagePrimaryText: Text.language.value,
            languageSymbolImage: languageSymbolImage,
            languageSecondaryText: languageSecondaryText)
        return Item.summary(summary)
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
        
        if let sellerURL = app.providerURL {
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
        
        let userRatingPrimaryText: String?
        let userRatingSymbolImage: UIImage?
        let userRatingSecondaryValue: Double?
        
        let contentAdivisoryRatingPrimaryText: String?
        let contentAdivisoryRatingSymbolImage: UIImage?
        let contentAdivisoryRatingSecondaryText: String?
        
        let providerPrimaryText: String?
        let providerSymbolImage: UIImage?
        let providerSecondaryText: String?
        
        let genrePrimaryText: String?
        let genreSymbolImage: UIImage?
        let genreSecondaryText: String?
        
        let languagePrimaryText: String?
        let languageSymbolImage: UIImage?
        let languageSecondaryText: String?
    }
    
    struct ReleaseNote: Hashable {
        
        private let versionValue: String?
        private let currentVersionReleaseDateValue: String?
        
        var description: String?
        var isTrucated: Bool
        
        init(version: String?, currentVersionReleaseDate: String?, description: String?,
             isTruncated: Bool) {
            self.versionValue = version
            self.currentVersionReleaseDateValue = currentVersionReleaseDate
            self.description = description
            self.isTrucated = isTruncated
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
            return isTrucated ? Text.moreDetails.value : Text.preview.value
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
