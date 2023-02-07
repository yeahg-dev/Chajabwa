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
        
        var title: String? = Text.error
        var message: String?
        var preferredStyle: UIAlertControllerStyle = .alert
        
    }
    
    struct RecentSearchKeywordReadFailureAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = Text.unable_to_download
        var message: String?
        var preferredStyle: UIAlertControllerStyle = .alert
        
    }
    
    struct RecentSearchKeywordDeleteFailureAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = Text.delete_failed
        var message: String?
        var preferredStyle: UIAlertControllerStyle = .alert
        
    }
    
    // MARK: - UIAlertActionViewModel
    
    struct OKActionViewModel: UIAlertActionViewModel {
        
        var title: String? = Text.confirm
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
    struct RetryActionViewModel: UIAlertActionViewModel {
        
        var title: String? = Text.please_try_again
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
    struct ReportToDeveloperActionViewModel: UIAlertActionViewModel {
        
        var title: String? = Text.report_bug
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
}
