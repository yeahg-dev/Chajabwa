//
//  SearchKeywordTableFooterViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/04.
//

import UIKit

struct SearchKeywordTableFooterViewModel {
    
    private let usecase = RecentSearchKeywordManagementUsecase(searchKeywordRepository: RealmSearchKeywordRepository()!)
    
    var deleteAllButtonTitle: String {
        return "전체 삭제"
    }
    
    var deleteAllButtonTitleColor: UIColor {
        return .black
    }
    
    func deleteAllButtonDidTapped(completion: @escaping() -> Void) {
        usecase.deleteAllRecentSearchKeywords { result in
            switch result {
            case .success(_):
                completion()
            case .failure(_):
                return
            }
        }
    }
    
}
