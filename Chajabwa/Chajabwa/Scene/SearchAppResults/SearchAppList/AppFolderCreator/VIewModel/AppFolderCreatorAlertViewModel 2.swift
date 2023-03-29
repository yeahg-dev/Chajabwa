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
        
        var title: String? = "폴더가 정상적으로 만들어지지 않았습니다"
        var message: String? = "다시 시도해주세요"
        var preferredStyle: UIAlertControllerStyle = .alert

    }
    
    
    struct ConfirmActionViewModel: UIAlertActionViewModel {
        
        var title: String? = "확인"
        var style: UIAlertActionStyle = .defaults
        var handler: ((UIAlertAction) -> Void)?
    
    }
    
}
