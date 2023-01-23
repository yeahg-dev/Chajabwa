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
        
        var title: String? = "데이터를 불러오는 데 실패했어요"
        var message: String? = "다시 시도해주세요"
        var preferredStyle: UIAlertControllerStyle = .alert
    }
    
    struct ConfirmActionViewModel: UIAlertActionViewModel {
        
        var title: String? = "확인"
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
        
        var title: String? = "폴더 수정"
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
    struct DeleteActionViewModel: UIAlertActionViewModel {
        
        var title: String? = "폴더 삭제"
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
        
        var title: String? = "폴더를 삭제하시겠어요?"
        var message: String? = "삭제하면 다시 복구할 수 없어요"
        var preferredStyle: UIAlertControllerStyle = .alert
    }
    
    struct CancelActionViewModel: UIAlertActionViewModel {
        
        var title: String? = "취소"
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
    // MARK: - AppFolderDeleteErrorAlertViewModel
    
    struct AppFolderDeleteErrorAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = AppFolderDeleteErrorAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [ConfirmActionViewModel()]
        
    }
    
    struct AppFolderDeleteErrorAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = "삭제를 실패했어요"
        var message: String? = "다시 시도해주세요"
        var preferredStyle: UIAlertControllerStyle = .alert
    }
    
    
}
