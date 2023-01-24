//
//  UIViewController+Extension.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/17.
//

import UIKit

extension UIViewController {
    
    internal func presentAlert(_ alertViewModel: AlertViewModel) {
        let alertController = UIAlertController(
            title: alertViewModel.alertController.title,
            message: alertViewModel.alertController.message,
            preferredStyle: alertViewModel.alertController.preferredStyle.value)
        if let alertActions = alertViewModel.alertActions {
            alertActions.forEach { actionViewModel in
                let action = UIAlertAction(
                    title: actionViewModel.title,
                    style: actionViewModel.style.value,
                    handler: actionViewModel.handler
                )
                alertController.addAction(action)
            }
        }
        
        present(alertController, animated: false)
    }
    
}
