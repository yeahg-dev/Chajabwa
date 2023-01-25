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
    
    private var appFolder: AppFolder!
    private var savedApps: [SavedApp]?
    
    struct Input {
        
        let viewWillRefresh: AnyPublisher<Void, Never>
        let selectedIndexPath: AnyPublisher<IndexPath, Never>
        let cellWillDeleteAt: AnyPublisher<IndexPath, Never>
        let editButtonDidTapped: AnyPublisher<Void, Never>
        let deleteButtonDidTapped: AnyPublisher<Void, Never>
        
    }
    
    struct Output {
        
        let headerViewModel: AnyPublisher<AppFolderDetailHeaderViewModel, Never>
        let errorAlertViewModel: AnyPublisher<AlertViewModel, Never>
        let selectedSavedAppDetail: AnyPublisher<AppDetail, Error>
        let cellDidDeletedAt: AnyPublisher<IndexPath?, Never>
        let presentAppFolderEditAlert: AnyPublisher<(AlertViewModel, AppFolder), Never>
        let presentAppFolderDeleteAlert: AnyPublisher<AlertViewModel, Never>
        let navigateToAppFolderListView: AnyPublisher<Void, Never>
        
        let EmptyViewguideLabelText: String?
        let goToSearchButtonTitle: String?
        let showEmptyView: AnyPublisher<Bool, Never>
        
    }
    
    var iconImageURL: String?
    
    var appFolderName: String?
    
    var appFolderDescription: String?
    
    let errorAlertViewModel = PassthroughSubject<AlertViewModel, Never>()
    
    let showEmptyView = PassthroughSubject<Bool, Never>()
    
    init(_ appFolderIdentifier: String) {
        super.init()
        Task {
            do {
                self.appFolder = await fetchLatedstAppFolder(appFolderIdentifier)
                self.savedApps = try await fetchLatestSavedApps()
            } catch {
                errorAlertViewModel.send(
                    AppFolderDetailAlertViewModel.SavedAppFetchFailureAlertViewModel())
            }
        }
    }
    
    func transform(_ input: Input) -> Output {
        
        let haederViewModelPublisher = input.viewWillRefresh
            .asyncMap { [unowned self] in
                await self.fetchLatedstAppFolder(self.appFolder.identifier)
            }
            .map { appFolder in
                return AppFolderDetailHeaderViewModel(
                    blurIconImageURL: appFolder.iconImageURL,
                    iconImagURL: appFolder.iconImageURL,
                    appFolderName: appFolder.name,
                    appFolderDescription: appFolder.description)
            }
            .eraseToAnyPublisher()
        
        let selectedSavedAppDetail = input.selectedIndexPath
            .map { [unowned self] indexPath in
                self.savedApps?[safe: indexPath.row] }
            .flatMap({ [unowned self] savedApp in
                return self.appFolderUsecase.readAppDetail(of: savedApp!)
            })
            .eraseToAnyPublisher()
        
        let cellDidDeletedAt = input.cellWillDeleteAt
            .asyncMap({ [unowned self] (indexPath) -> IndexPath? in
                guard let savedApp = self.savedApps?[safe: indexPath.row],
                      let appFolder = self.appFolder else {
                    self.errorAlertViewModel.send(
                        AppFolderDetailAlertViewModel.AppFolderDeleteErrorAlertViewModel())
                    return nil
                }
                do {
                    _ = try await self.appFolderUsecase.delete([savedApp], in: appFolder)
                    self.savedApps = try await self.fetchLatestSavedApps()
                    return indexPath
                } catch {
                    self.errorAlertViewModel.send(
                        AppFolderDetailAlertViewModel.AppFolderDeleteErrorAlertViewModel())
                    return nil
                }
            })
            .eraseToAnyPublisher()
        
        let presentAppFolderEditAlert = input.editButtonDidTapped
            .map{ [unowned self] in
                return ((AppFolderDetailAlertViewModel.AppFolderEditAlertViewModel() as AlertViewModel), self.appFolder ?? AppFolder.placeholder)
            }
            .eraseToAnyPublisher()
        
        let navigateToAppFolderListView = PassthroughSubject<Void, Never>()
        
        let presentAppFolderDeleteAlert = input.deleteButtonDidTapped
            .map { [unowned self] in
                var alertViewModel = AppFolderDetailAlertViewModel.AppFolderDeleteConfirmAlertViewModel()
                alertViewModel.alertActions?[1].handler = { _ in
                    Task {
                        do {
                            try await self.appFolderUsecase.deleteAppFolder(self.appFolder)
                            navigateToAppFolderListView.send(())
                        } catch {
                            self.errorAlertViewModel.send(AppFolderDetailAlertViewModel.AppFolderDeleteErrorAlertViewModel() as AlertViewModel)
                        }
                    }
                }
                return (alertViewModel as AlertViewModel)
            }
            .eraseToAnyPublisher()
        
        return Output(
            headerViewModel: haederViewModelPublisher,
            errorAlertViewModel: errorAlertViewModel.eraseToAnyPublisher(),
            selectedSavedAppDetail: selectedSavedAppDetail,
            cellDidDeletedAt: cellDidDeletedAt,
            presentAppFolderEditAlert: presentAppFolderEditAlert,
            presentAppFolderDeleteAlert: presentAppFolderDeleteAlert,
            navigateToAppFolderListView: navigateToAppFolderListView.eraseToAnyPublisher(),
            EmptyViewguideLabelText: Text.appFolderDetailEmptryViewGuide.rawValue,
            goToSearchButtonTitle: Text.goToSearch.rawValue,
            showEmptyView: showEmptyView.eraseToAnyPublisher()
        )
    }
    
    private func fetchLatestSavedApps() async throws -> [SavedApp] {
        try await appFolderUsecase.readSavedApps(of: appFolder)
    }
    
    private func fetchLatedstAppFolder(_ identifier: String) async -> AppFolder {
        do {
            return try await appFolderUsecase.readAppFolder(identifer: identifier)
        } catch {
            return AppFolder.placeholder
        }
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
