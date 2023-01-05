//
//  SearchKeywordAlertViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/05.
//

import Foundation

struct SearchKeywordAlertViewModel {
    
    struct RecentSearchKeywordReadFailure: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = RecentSearchKeywordReadFailureAlertController()
        var alertActions: [UIAlertActionViewModel]? = [RetryAction(), ReportToDeveloperAction()]
    }
    
    struct RecentSearchKeywordDeleteFailure: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = RecentSearchKeywordDeleteFailureAlertController()
        var alertActions: [UIAlertActionViewModel]? = [RetryAction(), ReportToDeveloperAction()]
        
    }
    
    struct RecentSearchKeywordReadFailureAlertController: UIAlertControllerViewModel {
        
        var title: String? = "검색 기록을 불러올 수 없습니다."
        var message: String?
        var preferredStyle: UIAlertControllerStyle = .alert
        
    }
    
    struct RecentSearchKeywordDeleteFailureAlertController: UIAlertControllerViewModel {
        
        var title: String? = "검색 기록을 삭제할 수 없습니다."
        var message: String?
        var preferredStyle: UIAlertControllerStyle = .alert
        
    }
    
    struct RetryAction: UIAlertActionViewModel {
        
        var title: String? = "재시도"
        var style: UIAlertActionStyle = .defaults
        
    }
    
    struct ReportToDeveloperAction: UIAlertActionViewModel {
        
        var title: String? = "개발자에게 버그 제보하기"
        var style: UIAlertActionStyle = .defaults
        
    }
    
}
