//
//  SearchKeywordTableHeaderViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/03.
//

import Foundation

struct SearchKeywordTableHeaderViewModel {
    
    private let usecase = RecentSearchKeywordManagementUsecase(
        searchKeywordRepository: RealmSearchKeywordRepository())
    
    var headerTitle: String {
        return Texts.recent_search_keyword
    }
    
    var savingSwitchTitle: String {
        return Texts.save
    }
    
    var isSavingSwithOn: Bool {
        return usecase?.isActiveSavingSearchingKeyword() ?? false
    }
    
    func switchStateDidChanged(to isOn: Bool) {
        if isOn == true {
            usecase?.activateSavingSearchKeyword()
        } else {
            usecase?.deactivateSavingSearchKeyword()
        }
        
    }
    
}
