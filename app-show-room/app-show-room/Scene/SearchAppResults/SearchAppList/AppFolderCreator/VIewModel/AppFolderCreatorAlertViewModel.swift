//
//  AppFolderCreatorAlertViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/16.
//

import UIKit

extension AppFolderCreatorViewModel {
    
    struct AppFolderCreationFailureAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = AppFolderCreationFailureAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [ConfirmActionViewModel()]
        
    }
    
    private struct AppFolderCreationFailureAlertControllerViewModel: UIAlertControllerViewModel{
        
        var title: String? = Texts.save_failed
        var message: String? = Texts.please_try_again
        var preferredStyle: UIAlertControllerStyle = .alert

    }
    
    
    private struct ConfirmActionViewModel: UIAlertActionViewModel {
        
        var title: String? = Texts.confirm
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
    
    }
    
}
