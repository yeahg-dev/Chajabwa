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
    
    private var fetchedCellModels: [SavedAppDetailTableViewCellModel?] = []
    
    private var cancellable = Set<AnyCancellable>()
    
    init(_ appFolderIdentifier: String) {
        super.init()
        Task {
            do {
                self.appFolder = await fetchLatedstAppFolder(appFolderIdentifier)
                self.savedApps = try await fetchLatestSavedApps()
                fetchedCellModels = .init(repeating: nil, count: savedApps?.count ?? 0)
            } catch {
                errorAlertViewModel.send(
                    SavedAppFetchFailureAlertViewModel())
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
                        AppFolderDeleteErrorAlertViewModel())
                    return nil
                }
                do {
                    _ = try await self.appFolderUsecase.delete([savedApp], in: appFolder)
                    self.savedApps = try await self.fetchLatestSavedApps()
                    return indexPath
                } catch {
                    self.errorAlertViewModel.send(
                        AppFolderDeleteErrorAlertViewModel())
                    return nil
                }
            })
            .eraseToAnyPublisher()
        
        let presentAppFolderEditAlert = input.editButtonDidTapped
            .map{ [unowned self] in
                return ((AppFolderEditAlertViewModel() as AlertViewModel), self.appFolder ?? AppFolder.placeholder)
            }
            .eraseToAnyPublisher()
        
        let navigateToAppFolderListView = PassthroughSubject<Void, Never>()
        
        let presentAppFolderDeleteAlert = input.deleteButtonDidTapped
            .map { [unowned self] in
                var alertViewModel = AppFolderDeleteConfirmAlertViewModel()
                alertViewModel.alertActions?[1].handler = { _ in
                    Task {
                        do {
                            try await self.appFolderUsecase.deleteAppFolder(self.appFolder)
                            navigateToAppFolderListView.send(())
                        } catch {
                            self.errorAlertViewModel.send(AppFolderDeleteErrorAlertViewModel() as AlertViewModel)
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
            EmptyViewguideLabelText: Texts.no_saved_app,
            goToSearchButtonTitle: Texts.go_search,
            showEmptyView: showEmptyView.eraseToAnyPublisher()
        )
    }
    
    private func fetchLatestSavedApps() async throws -> [SavedApp] {
        let savedApps = try await appFolderUsecase.readSavedApps(of: appFolder)
        fetchedCellModels = .init(repeating: nil, count: savedApps.count )
        return savedApps
    }
    
    private func fetchLatedstAppFolder(_ identifier: String) async -> AppFolder {
        do {
            return try await appFolderUsecase.readAppFolder(identifer: identifier)
        } catch {
            return AppFolder.placeholder
        }
    }
    
}

extension AppFolderDetailViewModel: UITableViewDataSourcePrefetching {
    
    func tableView(
        _ tableView: UITableView,
        prefetchRowsAt indexPaths: [IndexPath])
    {
        guard let savedApps else {
            return
        }
        Publishers.Sequence<[IndexPath], Never>(sequence: indexPaths)
            .map({ indexPath in
                return (indexPath.row, savedApps[indexPath.row])
            })
            .flatMap { (index, savedApp) -> AnyPublisher<(Int, SavedAppDetail), Error> in
                return self.appFolderUsecase.readSavedAppDetail(of: savedApp)
                    .map { savedAppDetail in
                        return (index, savedAppDetail)
                    }
                    .eraseToAnyPublisher()
            }
            .catch({ _ in
                return Just((0, SavedAppDetail.placeholder))
            })
            .map{ (index, savedAppDetail) in
                return (index, SavedAppDetailTableViewCellModel(savedAppDetail: savedAppDetail))
            }
            .sink { [unowned self] (index, cellModel) in
                self.fetchedCellModels[index] = cellModel
            }.store(in: &cancellable)
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
        
        if let cellModel = fetchedCellModels[indexPath.row] {
            cell.bind(cellModel)
        } else {
            let cellModel = appFolderUsecase.readSavedAppDetail(of: savedApp)
                .catch({ _ in
                    return Just(SavedAppDetail.placeholder)
                })
                .map { savedAppDetail in
                    return SavedAppDetailTableViewCellModel(savedAppDetail: savedAppDetail)
                }
                .eraseToAnyPublisher()

            cell.bind(cellModel)
        }

        return cell
    }

}
