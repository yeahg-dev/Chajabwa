//
//  AppDetailViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import UIKit

struct AppDetailViewModel {
    
    enum Section: Int, CaseIterable {
        case summary
        case releaseNote
        case screenshot
        case descritption
        case information
    }
    
    private let app: AppDetail
    
    init(app: AppDetail) {
        self.app = app
    }
    
    let sections: [Section] = Section.allCases
   
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
        if isTruncated {
            let fullReleaseNote = ReleaseNote(
                version: app.version,
                currentVersionReleaseDate: app.currentVersionReleaseDate,
                description: app.description,
                isTruncated: isTruncated)
            return Item.releaseNote(fullReleaseNote)
        } else {
            let previewReleaseNote = ReleaseNote(
                version: app.version,
                currentVersionReleaseDate: app.currentVersionReleaseDate,
                description: app.description,
                isTruncated: isTruncated)
            return Item.releaseNote(previewReleaseNote)
        }
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
        case .summary:
            let info = Info(
                name: app.appName,
                iconImageURL: app.iconImageURL,
                provider: app.provider,
                price: app.price)
            return [Item.summary(info)]
        case .releaseNote:
            let releaseNote = ReleaseNote(
                version: app.version,
                currentVersionReleaseDate: app.currentVersionReleaseDate,
                description: app.description)
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
        case summary(Info)
        case releaseNote(ReleaseNote)
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
    
    struct ReleaseNote: Hashable {
        private let versionValue: String?
        private let currentVersionReleaseDateValue: String?
        
        let description: String?
        var isTrucated: Bool = true
        
        var version: String? {
            if let versionValue = versionValue {
                return Text.version.value + " " + versionValue
            }
            return nil
        }
        
        var currentVersionReleaseDate: String? {
            return releaseDateRepresentation(currentVersionReleaseDateValue)
        }
        
        var buttonTitle: String {
            return isTrucated ? Text.moreDetails.value : Text.preview.value
        }
        
        init(version: String?, currentVersionReleaseDate: String?, description: String?,
             isTruncated: Bool = true) {
            self.versionValue = version
            self.currentVersionReleaseDateValue = currentVersionReleaseDate
            self.description = description
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
