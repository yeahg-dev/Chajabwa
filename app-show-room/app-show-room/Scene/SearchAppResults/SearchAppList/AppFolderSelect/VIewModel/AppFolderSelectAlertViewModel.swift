//
//  AppFolderSelectAlertViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/17.
//

import Foundation

struct AppFolderSelectAlertViewModel {
    
    struct SaveFailureAlertViewModel: AlertViewModel {
        
        var alertController: UIAlertControllerViewModel = SaveFailureAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]? = [ConfirmAction()]
        
    }
    
    struct SaveFailureAlertControllerViewModel: UIAlertControllerViewModel {
        
        var title: String? = "저장에 실패했습니다"
        var message: String? = "다시 시도해주세요"
        var preferredStyle: UIAlertControllerStyle = .alert

    }
    
    struct ConfirmAction: UIAlertActionViewModel {
        
        var title: String? = "확인"
        var style: UIAlertActionStyle = .defaults
    
    }
    
}
