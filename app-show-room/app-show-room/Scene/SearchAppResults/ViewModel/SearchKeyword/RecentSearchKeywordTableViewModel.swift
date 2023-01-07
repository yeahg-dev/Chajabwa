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
    
    private var keywords: [RecentSearchKeyword] = []
    
    private var cellModels: [RecentSearchKeywordCellModel] = []
    
    override init() {
        let recentSearchKeywordRepository = RealmSearchKeywordRepository()!
        self.recentSearchKeywordUsecase = RecentSearchKeywordManagementUsecase(
            searchKeywordRepository: recentSearchKeywordRepository)
        self.appSearchUsecase = AppSearchUsecase(
            searchKeywordRepository: recentSearchKeywordRepository)
        super.init()
        Task {
            await self.fetchLatestData()
        }
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
    
    func fetchLatestData() async {
        keywords = await fetchAllRecentSearchKeyword()
        cellModels = keywords.compactMap{ RecentSearchKeywordCellModel(keyword: $0) }
    }
    
    func cellDidSelected(
        at indexPath: IndexPath)
    async -> Output<[AppDetail], AlertViewModel>
    {
        let keyword = keywords[indexPath.row]
        do {
            let appDetails = try await self.appSearchUsecase.searchAppDetail(of: keyword)
            if appDetails.isEmpty {
                return .failure(SearchAlertViewModel.EmptyResultAlertViewModel())
            } else {
                return .success(appDetails)
            }
        } catch {
            return .failure(SearchAlertViewModel.SearchFailureAlertViewModel())
        }
    }
    
    func deleteRecentSearchKeyword(
        at indexPath: IndexPath) async {
            let cell = keywords[indexPath.row]
            print("🗑deleteRecentSearchKeyword 호출")
            do {
                let _ = try await recentSearchKeywordUsecase.deleteRecentSearchKeyword(of: cell.identifier)
                await self.fetchLatestData()
                return
            } catch {
                self.searchAppResultTableViewUpdater?.presentAlert(
                    SearchKeywordAlertViewModel.RecentSearchKeywordDeleteFailure())
                print("Failed to Delete RecentSearchKeyword. error: \(error)")
                return
            }
        }
    
    func deleteAllRecentSearchKeyword() async {
        do {
            let _ = try await recentSearchKeywordUsecase.deleteAllRecentSearchKeywords()
            await self.fetchLatestData()
        } catch {
            self.searchAppResultTableViewUpdater?.presentAlert(
                SearchKeywordAlertViewModel.RecentSearchKeywordDeleteFailure())
            print("Failed to DeleteAll RecentSearchKeyword. error: \(error)")
        }
    }
    
    private func fetchAllRecentSearchKeyword() async -> [RecentSearchKeyword] {
        do {
            return try await recentSearchKeywordUsecase.allRecentSearchKeywords()
        } catch {
            print("Failed to fetch RecentSearchKeyword. error: \(error)")
            return []
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
        ) {  [unowned self] _, _, _ in
            Task {
                await self.deleteRecentSearchKeyword(at: indexPath)
                print("delete와 MainActor 사이")
                await MainActor.run {
                    print("MainActor에서 reloadData실행")
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
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
            await fetchLatestData()
            await MainActor.run {
                tableView.reloadData()
            }
        }
        
    }
    
}
