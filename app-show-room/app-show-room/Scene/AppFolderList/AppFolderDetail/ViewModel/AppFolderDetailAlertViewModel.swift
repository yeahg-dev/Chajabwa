//
//  AppFolderDetailAlertViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/20.
//

import UIKit

struct AppFolderDetailAlertViewModel {
    
    struct SavedAppFetchFailureAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = SavedAppFetchFailureAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [ConfirmActionViewModel()]
    }
    
    struct SavedAppFetchFailureAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = Text.unable_to_download
        var message: String? = Text.please_try_again
        var preferredStyle: UIAlertControllerStyle = .alert
    }
    
    struct ConfirmActionViewModel: UIAlertActionViewModel {
        
        var title: String? = Text.confirm
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
    // MARK: - AppFolderEditAlertViewModel
    
    struct AppFolderEditAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = AppFolderEditAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [
            EditActionViewModel(), DeleteActionViewModel()]
        
    }

    struct AppFolderEditAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = nil
        var message: String? = nil
        var preferredStyle: UIAlertControllerStyle = .actionSheet
    }
    
    struct EditActionViewModel: UIAlertActionViewModel {
        
        var title: String? = Text.app_folder_eidt
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
    struct DeleteActionViewModel: UIAlertActionViewModel {
        
        var title: String? = Text.app_folder_delete
        var style: UIAlertActionStyle = .destructive
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
    // MARK: - AppFolderDeleteConfirmAlertViewModel
    
    struct AppFolderDeleteConfirmAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = AppFolderDeleteConfirmAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [
            CancelActionViewModel(), ConfirmActionViewModel()]
        
    }

    struct AppFolderDeleteConfirmAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = Text.app_folder_delete_reconfirm
        var message: String? = Text.delete_warning
        var preferredStyle: UIAlertControllerStyle = .alert
    }
    
    struct CancelActionViewModel: UIAlertActionViewModel {
        
        var title: String? = Text.cancel
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
    // MARK: - AppFolderDeleteErrorAlertViewModel
    
    struct AppFolderDeleteErrorAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = AppFolderDeleteErrorAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [ConfirmActionViewModel()]
        
    }
    
    struct AppFolderDeleteErrorAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = Text.delete_failed
        var message: String? = Text.please_try_again
        var preferredStyle: UIAlertControllerStyle = .alert
    }
    
}
