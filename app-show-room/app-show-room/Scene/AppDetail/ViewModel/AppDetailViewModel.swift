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
    
    var hyperlinkInformationsIndexPaths: [IndexPath] {
        var indexPaths = [IndexPath]()
        let totalInforationItem = textInformations.count + hyperLinkInformations.count
        for index in textInformations.count ..< totalInforationItem {
            let hyperlinkInformationIndexPath = IndexPath(row: index, section: Section.information.rawValue)
            indexPaths.append(hyperlinkInformationIndexPath)
        }
        return indexPaths
    }
    
    func cellItems(at section: Int) -> [Item] {
        // TODO: - 옵셔널 오류 핸들링
        let section = Section(rawValue: section)
        
        return cellItem(at: section!)
    }
    
    func releaseNote(isTruncated: Bool) -> Item {
        if isTruncated {
            let fullReleaseNote = ReleaseNote(
                version: versionText(app.version),
                currentVersionReleaseDate: releaseDateRepresentation(app.currentVersionReleaseDate),
                description: app.releaseDescription,
                isTrucated: isTruncated)
            return Item.releaseNote(fullReleaseNote)
        } else {
            let previewReleaseNote = ReleaseNote(
                version: versionText(app.version),
                currentVersionReleaseDate: releaseDateRepresentation(app.currentVersionReleaseDate),
                description: app.releaseDescription,
                isTrucated: isTruncated)
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
    
    private var hyperLinkInformations: [Item] {
        var inforamtions = [Information]()
        
        if let sellerURL = app.sellerURL {
            inforamtions.append(Information(
                category: Text.developerWebsite.value,
                value: sellerURL,
                image: UIImage(systemName: "safari.fill")))
        }

        return inforamtions.map { Item.information($0) }
    }
    
    private func cellItem(at section: Section) -> [Item] {
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
                version: versionText(app.version),
                currentVersionReleaseDate: releaseDateRepresentation(app.currentVersionReleaseDate),
                description: app.releaseDescription)
            return [Item.releaseNote(releaseNote)]
        case .screenshot:
            // TODO: - 강제 언래핑 제거
            let items = app.screenShotURLs?.map { Screenshot(url: $0) }
                .map{ Item.screenshot($0) }
            return items!
        case .descritption:
            let truncatedDescription = app.description
            let description = Description(text: truncatedDescription)
            return [Item.description(description)]
        case .information:
           return textInformations + hyperLinkInformations
        }
    }
    
    private func versionText(_ version: String?) -> String? {
        guard let version = version else {
            return nil
        }
        
        return Text.version.value + " " + version
    }
    
    private func releaseDateRepresentation(_ string: String?) -> String? {
        guard let string = string,
              let releaseDate = ISO8601DateFormatter().date(from: string) else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: releaseDate)
    }

}

extension AppDetailViewModel {
    
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
        let version: String?
        let currentVersionReleaseDate: String?
        let description: String?
        var isTrucated: Bool = true
        
        var buttonTitle: String {
            return isTrucated ? Text.moreDetails.value : Text.preview.value
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
