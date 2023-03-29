//
//  SearchKeywordAlertViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/05.
//

import UIKit

struct SearchKeywordAlertViewModel {
    
    // MARK: - AlertViewModel
    
    struct RecentSearckKeywordRepositoryFailure: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = RecentSearckKeywordRepositoryFailureAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [OKActionViewModel()]
        
    }
    
    struct RecentSearchKeywordReadFailure: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = RecentSearchKeywordReadFailureAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [
            RetryActionViewModel(), ReportToDeveloperActionViewModel()]
        
    }
    
    struct RecentSearchKeywordDeleteFailure: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = RecentSearchKeywordDeleteFailureAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [
            RetryActionViewModel(), ReportToDeveloperActionViewModel()]
        
    }
    
    // MARK: - UIAlertControllerViewModel
    
    struct RecentSearckKeywordRepositoryFailureAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = "검색 기록 기능을 사용할 수 없습니다."
        var message: String?
        var preferredStyle: UIAlertControllerStyle = .alert
        
    }
    
    struct RecentSearchKeywordReadFailureAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = "검색 기록을 불러올 수 없습니다."
        var message: String?
        var preferredStyle: UIAlertControllerStyle = .alert
        
    }
    
    struct RecentSearchKeywordDeleteFailureAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = "검색 기록을 삭제할 수 없습니다."
        var message: String?
        var preferredStyle: UIAlertControllerStyle = .alert
        
    }
    
    // MARK: - UIAlertActionViewModel
    
    struct OKActionViewModel: UIAlertActionViewModel {
        
        var title: String? = "확인"
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
    struct RetryActionViewModel: UIAlertActionViewModel {
        
        var title: String? = "재시도"
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
    struct ReportToDeveloperActionViewModel: UIAlertActionViewModel {
        
        var title: String? = "개발자에게 버그 제보하기"
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
}
