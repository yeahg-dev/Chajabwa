//
//  RecentSearchKeywordTableViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/01.
//

import UIKit

protocol SearchAppResultTableViewUpdater: AnyObject {
    
    func updateSearchAppResultTableView(with searchApps: [AppDetail])
    
    func presentAlert(_ alertViewModel: AlertViewModel)
    
}

final class RecentSearchKeywordTableViewModel: NSObject {
    
    weak var appDetailViewPresenter: AppDetailViewPresenter?
    weak var searchAppResultTableViewUpdater: SearchAppResultTableViewUpdater?
    
    private let recentSearchKeywordUsecase: RecentSearchKeywordManagementUsecase
    private let appSearchUsecase: AppSearchUsecase
    
    private var keywords: [RecentSearchKeyword] = [] {
        willSet(newKeywords) {
            cellModels = newKeywords.compactMap{ RecentSearchKeywordCellModel(keyword: $0)}
        }
    }
    
    // Publisher로 구현?
    private var cellModels: [RecentSearchKeywordCellModel] = []
    
    override init() {
        let recentSearchKeywordRepository = RealmSearchKeywordRepository()!
        self.recentSearchKeywordUsecase = RecentSearchKeywordManagementUsecase(
                searchKeywordRepository: recentSearchKeywordRepository)
        self.appSearchUsecase = AppSearchUsecase(
                searchKeywordRepository: recentSearchKeywordRepository)
        super.init()
        self.fetchSearchKeywordCellModels(completion: { return })
    }
    
    var title: String {
        return "최근 검색어"
    }
    
    var savingSwtichTitle: String {
        return "저장"
    }
    
    var deleteAllButtonTitle: String {
        return "전체 삭제"
    }

    var savingModeOffDescription: String {
        return "검색어 저장 기능이 꺼져 있습니다."
    }
    
    var isActivateSavingButton: Bool {
        return recentSearchKeywordUsecase.isActiveSavingSearchingKeyword()
    }

    func fetchLatestData(completion: @escaping () -> Void) {
        fetchSearchKeywordCellModels(completion: completion)
    }

    func cellDidSelected(
        at indexPath: IndexPath)
    async -> Output<[AppDetail], AlertViewModel>
    {
        let keyword = keywords[indexPath.row]
        do {
            let appDetails = try await self.appSearchUsecase.searchAppDetail(of: keyword)
            if appDetails.isEmpty {
                return .failure(SearchSceneNamespace.emptyResultAlertViewModel)
            } else {
                return .success(appDetails)
            }
        } catch {
            return .failure(SearchSceneNamespace.searchFailureAlertViewModel)
        }
    }

    func cellDidDeleted(
        at indexPath: IndexPath,
        completion: @escaping () -> Void) {
        let cell = keywords[indexPath.row]
        recentSearchKeywordUsecase.deleteRecentSearchKeyword(
            of: cell.identifier) { result in
                switch result {
                case .success(_):
                    self.fetchLatestData(completion: completion)
                case .failure(let failure):
                    self.searchAppResultTableViewUpdater?.presentAlert(
                        SearchKeywordAlertViewModel.RecentSearchKeywordDeleteFailure())
                    print("Failed to Delete RecentSearchKeyword. error: \(failure)")
                }
            }
    }
    
    func allCellDidDeleted(completion: @escaping () -> Void) {
        recentSearchKeywordUsecase.deleteAllRecentSearchKeywords { result in
            switch result {
            case .success(_):
                self.fetchLatestData(completion: completion)
            case .failure(let failure):
                self.searchAppResultTableViewUpdater?.presentAlert(
                    SearchKeywordAlertViewModel.RecentSearchKeywordDeleteFailure())
                print("Failed to DeleteAll RecentSearchKeyword. error: \(failure)")
            }
        }
    }
    
    private func fetchSearchKeywordCellModels(completion: @escaping () -> Void) {
        recentSearchKeywordUsecase.allRecentSearchKeywords { result in
            switch result {
            case .success(let fetchedKeywords):
                //TODO: - Struct로 변경하기
                self.keywords = fetchedKeywords
                completion()
            case .failure(let failure):
                print("Failed to fetch RecentSearchKeyword. error: \(failure)")
                completion()
            }
        }
    }
    
}

// MARK: - UITableViewDataSource

extension RecentSearchKeywordTableViewModel: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
    -> Int
    {
        return cellModels.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withClass: RecentSearchKeywordTableViewCell.self,
            for: indexPath)
        let cellModel = cellModels[indexPath.row]
        cell.bind(cellModel)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "삭제"
        ) {  [weak self] _, _, _ in
            self?.cellDidDeleted(
                at: indexPath,
                completion: {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                })
        }
        
        let actionConfigurations = UISwipeActionsConfiguration(
            actions: [deleteAction])
        return actionConfigurations
    }
  
}

// MARK: - UITableViewDelegate

extension RecentSearchKeywordTableViewModel: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        Task {
            let result = await cellDidSelected(at: indexPath)
            switch result {
            case .success(let appDetail):
                if appDetail.count == 1 {
                    appDetailViewPresenter?.pushAppDetailView(of: appDetail.first!)
                } else {
                    searchAppResultTableViewUpdater?.updateSearchAppResultTableView(
                        with: appDetail)
                }
            case .failure(let alertViewModel):
                searchAppResultTableViewUpdater?.presentAlert(alertViewModel)
            }
            fetchLatestData {
                tableView.reloadData()
            }
        }
    }
    
}
