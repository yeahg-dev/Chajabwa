//
//  AppFolderEditAlertViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/23.
//

import UIKit

struct AppFolderEditAlertViewModel {
    
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
    
    struct ConfirmActionViewModel: UIAlertActionViewModel {
        
        var title: String? = "확인"
        var style: UIAlertActionStyle = .destructive
        var handler: ((UIAlertAction) -> Void)?
        
    }
    
    // MARK: - AppFolderSaveFailureAlertViewModel
    
    struct AppFolderSaveFailureAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = AppFolderDeleteConfirmAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [ConfirmActionViewModel()]
        
    }

    struct AppFolderSaveFailureAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = "저장을 실패했어요"
        var message: String? = "다시 시도해주세요"
        var preferredStyle: UIAlertControllerStyle = .alert
    }

}
