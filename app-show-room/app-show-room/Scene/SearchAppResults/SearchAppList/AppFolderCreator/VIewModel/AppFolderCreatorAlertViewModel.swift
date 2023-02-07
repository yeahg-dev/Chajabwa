//
//  AppFolderCreatorAlertViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/16.
//

import UIKit

struct AppFolderCreatorAlertViewModel {
    
    struct AppFolderCreationFailureAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = AppFolderCreationFailureAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [ConfirmActionViewModel()]
        
    }
    
    struct AppFolderCreationFailureAlertControllerViewModel: UIAlertControllerViewModel{
        
        var title: String? = Text.save_failed
        var message: String? = Text.please_try_again
        var preferredStyle: UIAlertControllerStyle = .alert

    }
    
    
    struct ConfirmActionViewModel: UIAlertActionViewModel {
        
        var title: String? = Text.confirm
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
    
    }
    
}
