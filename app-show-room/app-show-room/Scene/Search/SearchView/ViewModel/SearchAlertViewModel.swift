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
        
        var title: String? = "ID를 다시 확인해주세요"
        var message: String? = "숫자만 입력 할 수 있어요"
        var preferredStyle: UIAlertControllerStyle = .alert
    }
    
    private struct SearchFailureAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = "검색에 실패했습니다"
        var message: String? = "다시 시도해주세요🙏🏻"
        var preferredStyle: UIAlertControllerStyle = .alert
    }
    
    private struct EmptyResultAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = "결과가 없습니다"
        var message: String? = "검색어를 확인해주세요"
        var preferredStyle: UIAlertControllerStyle = .alert
    }
    
    private struct CountryCodeDownloadErrorAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = "앱 데이터 다운로드를 실패했습니다"
        var message: String? = "다시 시도해주세요🙏🏻"
        var preferredStyle: UIAlertControllerStyle = .alert
        
    }
    
    // MARK: - UIAlertActionViewModel
    
    private struct ConfirmActionViewModel: UIAlertActionViewModel {
        
        var title: String? = Text.confirm
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
}
