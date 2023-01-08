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
        return "최근 검색어"
    }
    
    var savingSwitchTitle: String {
        return "저장"
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
