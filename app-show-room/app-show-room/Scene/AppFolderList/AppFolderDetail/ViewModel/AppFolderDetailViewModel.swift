//
//  AppFolderDetailViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/19.
//

import Combine
import UIKit

final class AppFolderDetailViewModel: NSObject {
    
    private let appFolderUsecase = AppFolderUsecase()
    
    private let appFolder: AppFolder
    private var savedApps: [SavedApp]?
    
    struct Input {
        
        let selectedIndexPath: AnyPublisher<IndexPath, Never>
        
    }
    
    struct Output {
        
        let blurIconImage: UIImage?
        let iconImagURL: String?
        let appFolderName: String?
        let appFolderDescription: String?
        let errorAlertViewModel: AnyPublisher<AlertViewModel, Never>
        let selectedSavedApp: AnyPublisher<SavedApp?, Never>
        
    }
    
    // TODO: - Refactoring
    var blurIconImage: UIImage? {
        get async {
            return await self.image(downloadFrom: iconImageURL)
        }
    }
    
    var iconImageURL: String?
    
    var appFolderName: String?
    
    var appFolderDescription: String?
    
    let errorAlertViewModel = PassthroughSubject<AlertViewModel, Never>()
    
    init(_ appFolder: AppFolder) {
        self.appFolder = appFolder
        self.iconImageURL = appFolder.iconImageURL
        self.appFolderName = appFolder.name
        self.appFolderDescription = appFolder.description
        super.init()
        Task {
            do {
                try await fetchLatestData()
            } catch {
                errorAlertViewModel.send(
                    AppFolderDetailAlertViewModel.SavedAppFetchFailureAlertViewModel())
            }
        }
    }
    
    func transform(_ input: Input) async -> Output {
        let selectedSavedApp = input.selectedIndexPath
            .map { [weak self] indexPath in
                self?.savedApps?[safe: indexPath.row] }
            .eraseToAnyPublisher()
        
        return await Output(
            blurIconImage: blurIconImage,
            iconImagURL: iconImageURL,
            appFolderName: appFolderName,
            appFolderDescription: appFolderDescription,
            errorAlertViewModel: errorAlertViewModel.eraseToAnyPublisher(),
            selectedSavedApp: selectedSavedApp)
    }
    
    private func fetchLatestData() async throws {
        savedApps = try await appFolderUsecase.readSavedApps(of: appFolder)
    }
    
}

extension AppFolderDetailViewModel: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
    -> Int
    {
        return savedApps?.count ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withClass: SavedAppDetailTableViewCell.self,
            for: indexPath)
        guard let savedApp = savedApps?[safe: indexPath.row] else {
            return cell
        }
        
        // TODO: - Error Handling
        let cellModel = appFolderUsecase.readSavedAppDetail(of: savedApp)
            .map { savedAppDetail in
                return SavedAppDetailTableViewCellModel(savedAppDetail: savedAppDetail)
            }
            .assertNoFailure()
            .eraseToAnyPublisher()
        
        cell.bind(cellModel)
        return cell
    }
    
    private func image(downloadFrom urlString: String?) async -> UIImage? {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return nil
        }
        
        let imageCache = ImageCache()
        let cacheKey = urlString
        
        if let cachedImage = imageCache.getImage(of: cacheKey) {
            return cachedImage
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                return nil
            }
            let image = UIImage(data: data)
            return image
        } catch {
            return nil
        }
    }
    
}
