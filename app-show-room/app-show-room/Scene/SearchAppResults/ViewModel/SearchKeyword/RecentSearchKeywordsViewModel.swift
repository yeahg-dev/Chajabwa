//
//  RecentSearchKeywordsViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/01.
//

import Foundation

class RecentSearchKeywordsViewModel {
    
    private let usecase: RecentSearchKeywordManagementUsecase
    
    private var keywords: [RecentSearchKeyword] = [] {
        willSet(newKeywords) {
            cellModels = newKeywords.compactMap{ RecentSearchKeywordCellModel(keyword: $0)}
        }
    }
    
    // Publisher로 구현?
    private var cellModels: [RecentSearchKeywordCellModel] = []
    
    init?() {
        if let recentSearchKeywordRepository = RealmSearchKeywordRepository() {
            self.usecase = RecentSearchKeywordManagementUsecase(
                searchKeywordRepository: recentSearchKeywordRepository)
            self.fetchSearchKeywordCellModels(completion: { return })
        } else {
            return nil
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
        return usecase.isActiveSavingSearchingKeyword()
    }
    
    var numberOfSearchKeywordCell: Int {
        return cellModels.count
    }
    
    func searchKeywordCellModel(
        at indexPath: IndexPath,
        by timeAsecending: Bool = true)
    -> RecentSearchKeywordCellModel
    {
        return cellModels[indexPath.row]
    }
    
    func keywordDidSearched() {
        fetchSearchKeywordCellModels(completion: { return })
    }
    
    func fetchLatestData(completion: @escaping () -> Void) {
        fetchSearchKeywordCellModels(completion: completion)
    }

    // TODO: - 셀 선택 -> searchVC에게 키워드 전달해야함 -> Usecase에서 찾고 -> SearchVC에서 보여주기
    func cellDidSelected(at indexPath: IndexPath) -> RecentSearchKeyword {
        return keywords[indexPath.row]
    }

    func cellDidDeleted(
        at indexPath: IndexPath,
        completion: @escaping () -> Void) {
        let cell = keywords[indexPath.row]
        usecase.deleteRecentSearchKeyword(
            of: cell.identifier) { result in
                switch result {
                case .success(_):
                    self.fetchLatestData(completion: completion)
                case .failure(let failure):
                    // TODO: - Alert 구현!
                    print("Failed to Delete RecentSearchKeyword. error: \(failure)")
                }
            }
    }
    
    func allCellDidDeleted(completion: @escaping () -> Void) {
        usecase.deleteAllRecentSearchKeywords { result in
            switch result {
            case .success(_):
                self.fetchLatestData(completion: completion)
            case .failure(let failure):
                // TODO: - Alert 구현!
                print("Failed to DeleteAll RecentSearchKeyword. error: \(failure)")
            }
        }
    }
    
    private func fetchSearchKeywordCellModels(completion: @escaping () -> Void) {
        usecase.allRecentSearchKeywords { result in
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
