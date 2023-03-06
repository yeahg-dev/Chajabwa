//
//  AppFolderDetailAlertViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/20.
//

import UIKit

extension AppFolderDetailViewModel {
    
    struct SavedAppFetchFailureAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = SavedAppFetchFailureAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [ConfirmActionViewModel()]
    }
    
    private struct SavedAppFetchFailureAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = Texts.unable_to_download
        var message: String? = Texts.please_try_again
        var preferredStyle: UIAlertControllerStyle = .alert
    }
    
    private struct ConfirmActionViewModel: UIAlertActionViewModel {
        
        var title: String? = Texts.confirm
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
    // MARK: - AppFolderEditAlertViewModel
    
    struct AppFolderEditAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = AppFolderEditAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [
            EditActionViewModel(), DeleteActionViewModel()]
        
    }

    private struct AppFolderEditAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = nil
        var message: String? = nil
        var preferredStyle: UIAlertControllerStyle = .actionSheet
    }
    
    private struct EditActionViewModel: UIAlertActionViewModel {
        
        var title: String? = Texts.app_folder_eidt
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
    private struct DeleteActionViewModel: UIAlertActionViewModel {
        
        var title: String? = Texts.app_folder_delete
        var style: UIAlertActionStyle = .destructive
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
    // MARK: - AppFolderDeleteConfirmAlertViewModel
    
    struct AppFolderDeleteConfirmAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = AppFolderDeleteConfirmAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [
            CancelActionViewModel(), ConfirmActionViewModel()]
        
    }

    private struct AppFolderDeleteConfirmAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = Texts.app_folder_delete_reconfirm
        var message: String? = Texts.delete_warning
        var preferredStyle: UIAlertControllerStyle = .alert
    }
    
    private struct CancelActionViewModel: UIAlertActionViewModel {
        
        var title: String? = Texts.cancel
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
    // MARK: - AppFolderDeleteErrorAlertViewModel
    
    struct AppFolderDeleteErrorAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = AppFolderDeleteErrorAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [ConfirmActionViewModel()]
        
    }
    
    private struct AppFolderDeleteErrorAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = Texts.delete_failed
        var message: String? = Texts.please_try_again
        var preferredStyle: UIAlertControllerStyle = .alert
    }
    
}
