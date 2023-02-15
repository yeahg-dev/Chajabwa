//
//  AppFolderSelectAlertViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/17.
//

import UIKit

extension AppFolderSelectViewModel {
    
    struct SaveFailureAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = SaveFailureAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [ConfirmAction()]
        
    }
    
    private struct SaveFailureAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = Text.save_failed
        var message: String? = Text.please_try_again
        var preferredStyle: UIAlertControllerStyle = .alert

    }
    
    private struct ConfirmAction: UIAlertActionViewModel {
        
        var title: String? = Text.confirm
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
    
    }
    
}
