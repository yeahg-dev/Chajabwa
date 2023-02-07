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
        
        var title: String? = Text.save_failed
        var message: String? = Text.please_try_again
        var preferredStyle: UIAlertControllerStyle = .alert
    }
    
    struct ConfirmActionViewModel: UIAlertActionViewModel {
        
        var title: String? = Text.confirm
        var style: UIAlertActionStyle = .destructive
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
}
