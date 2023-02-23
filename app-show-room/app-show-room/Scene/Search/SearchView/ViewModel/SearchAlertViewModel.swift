//
//  SearchAlertViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/12.
//

import UIKit

extension SearchViewModel {
    
    struct InvalidInputAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = InvalidInputAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [ConfirmActionViewModel()]
    }
    
    struct SearchFailureAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = SearchFailureAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [ConfirmActionViewModel()]
    }
    
    struct EmptyResultAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = EmptyResultAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [ConfirmActionViewModel()]
    }
    
    struct CountryCodeDownloadErrorAlertViewModel: AlertViewModel {
        var alertController: UIAlertControllerViewModel = CountryCodeDownloadErrorAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [ConfirmActionViewModel()]
    }
    
    // MARK: - UIAlertControllerViewModel
    
    private struct InvalidInputAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = Texts.please_check_id_again
        var message: String? = Texts.enter_only_numbers_for_id
        var preferredStyle: UIAlertControllerStyle = .alert
    }
    
    private struct SearchFailureAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = Texts.search_failed
        var message: String? = Texts.please_try_again
        var preferredStyle: UIAlertControllerStyle = .alert
    }
    
    private struct EmptyResultAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = Texts.no_results
        var message: String? = Texts.please_check_keyword_again
        var preferredStyle: UIAlertControllerStyle = .alert
    }
    
    private struct CountryCodeDownloadErrorAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = Texts.app_data_download_failed
        var message: String? = Texts.please_try_again
        var preferredStyle: UIAlertControllerStyle = .alert
        
    }
    
    // MARK: - UIAlertActionViewModel
    
    private struct ConfirmActionViewModel: UIAlertActionViewModel {
        
        var title: String? = Texts.confirm
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
}
