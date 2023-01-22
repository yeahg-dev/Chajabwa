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
        
        let blurIconImageURL: String?
        let iconImagURL: String?
        let appFolderName: String?
        let appFolderDescription: String?
        let errorAlertViewModel: AnyPublisher<AlertViewModel, Never>
        let selectedSavedAppDetail: AnyPublisher<AppDetail, Error>
        
        let EmptyViewguideLabelText: String?
        let goToSearchButtonTitle: String?
        let showEmptyView: AnyPublisher<Bool, Never>
        
    }
    
    var iconImageURL: String?
    
    var appFolderName: String?
    
    var appFolderDescription: String?
    
    let errorAlertViewModel = PassthroughSubject<AlertViewModel, Never>()
    
    let showEmptyView = PassthroughSubject<Bool, Never>()
    
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
    
    func transform(_ input: Input) -> Output {
        let selectedSavedAppDetail = input.selectedIndexPath
            .map { [weak self] indexPath in
                self?.savedApps?[safe: indexPath.row] }
            .flatMap({ savedApp in
                return self.appFolderUsecase.readAppDetail(of: savedApp!)
            })
            .eraseToAnyPublisher()
        
        return Output(
            blurIconImageURL: iconImageURL,
            iconImagURL: iconImageURL,
            appFolderName: appFolderName,
            appFolderDescription: appFolderDescription,
            errorAlertViewModel: errorAlertViewModel.eraseToAnyPublisher(),
            selectedSavedAppDetail: selectedSavedAppDetail,
            EmptyViewguideLabelText: Text.appFolderDetailEmptryViewGuide.rawValue,
            goToSearchButtonTitle: Text.goToSearch.rawValue,
            showEmptyView: showEmptyView.prefix(1).eraseToAnyPublisher()
        )
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
        if let savedApps,
           savedApps.isEmpty {
            showEmptyView.send(true)
        } else {
            showEmptyView.send(false)
        }
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
    
}
