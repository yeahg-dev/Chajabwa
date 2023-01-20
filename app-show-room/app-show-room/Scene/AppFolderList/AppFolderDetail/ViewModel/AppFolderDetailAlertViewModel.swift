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
    }
    
}
