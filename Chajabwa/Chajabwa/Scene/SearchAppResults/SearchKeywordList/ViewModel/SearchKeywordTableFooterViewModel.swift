//
//  SearchKeywordTableFooterViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/04.
//

import UIKit

struct SearchKeywordTableFooterViewModel {
    
    private let usecase = RecentSearchKeywordManagementUsecase(
        searchKeywordRepository: RealmSearchKeywordRepository())
    
    var deleteAllButtonTitle: String {
        return Texts.delete_all
    }
    
    var deleteAllButtonTitleColor: UIColor {
        return .black
    }

    func deleteAllButtonDidTapped() async {
        do {
            let _ = try await usecase?.deleteAllRecentSearchKeywords()
            return
        } catch {
            print("Failed to Delete RecentSearchKeyword. error: \(error)")
            return
        }
    }
    
}
