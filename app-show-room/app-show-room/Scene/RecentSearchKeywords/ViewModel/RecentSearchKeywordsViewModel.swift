//
//  RecentSearchKeywordsViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/01.
//

import Foundation

struct RecentSearchKeywordsViewModel {
    
    private let usecase: RecentSearchKeywordManagementUsecase
    
    private var keywords: [RecentSearchKeyword] = [] {
        willSet(newKeywords) {
            cellModels = newKeywords.compactMap{ RecentSearchKeywordCellModel(keyword: $0)}
        }
    }
    
    private var cellModels: [RecentSearchKeywordCellModel] = []
    
    init?() {
        if let recentSearchKeywordRepository = RealmSearchKeywordRepository() {
            self.usecase = RecentSearchKeywordManagementUsecase(
                searchKeywordRepository: recentSearchKeywordRepository)
            self.fetchSearchKeywordCellModels()
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
    
    // 셀 선택 -> searchVC에게 키워드 전달해야함 -> Usecase에서 찾고 -> SearchVC에서 보여주기
    func didSelectedCell(at indexPath: IndexPath) -> RecentSearchKeyword {
        return keywords[indexPath.row]
    }

    mutating func didDeleteCell(at indexPath: IndexPath) {
        let cell = keywords[indexPath.row]
        do {
            try usecase.deleteRecentSearchKeyword(of: cell.identifier)
            self.fetchSearchKeywordCellModels()
        } catch  {
            print("Failed to Delete RecentSearchKeyword. error: \(error)")
        }
    }
    
    mutating func didDeleteAllCell() {
        do {
            try usecase.deleteAllRecentSearchKeywords()
            self.fetchSearchKeywordCellModels()
        } catch {
            print("Failed to DeleteAll RecentSearchKeyword. error: \(error)")
        }
    }
    
    private mutating func fetchSearchKeywordCellModels() {
        do {
            keywords = try usecase.recentSearchKeywords()
        } catch {
            print("Failed to fetch RecentSearchKeyword. error: \(error)")
        }
    }
    
}
