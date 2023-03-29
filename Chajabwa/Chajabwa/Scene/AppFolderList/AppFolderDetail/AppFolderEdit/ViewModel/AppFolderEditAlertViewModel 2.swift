//
//  AppFolderEditAlertViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/23.
//

import UIKit

struct AppFolderEditAlertViewModel {
 
    // MARK: - AppFolderSaveFailureAlertViewModel
    
    struct AppFolderSaveFailureAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = AppFolderSaveFailureAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [ConfirmActionViewModel()]
        
    }

    struct AppFolderSaveFailureAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = "저장을 실패했어요"
        var message: String? = "다시 시도해주세요"
        var preferredStyle: UIAlertControllerStyle = .alert
    }
    
    struct ConfirmActionViewModel: UIAlertActionViewModel {
        
        var title: String? = "확인"
        var style: UIAlertActionStyle = .destructive
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
}
