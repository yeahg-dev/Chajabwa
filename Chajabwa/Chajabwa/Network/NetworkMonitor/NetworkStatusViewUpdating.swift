//
//  NetworkStatusViewUpdating.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/03/25.
//

import UIKit

protocol NetworkStatusViewUpdating {
    
    func presentNetworkErrorAlertWith(retry action: @escaping (() -> Void))
    
}

extension UIViewController: NetworkStatusViewUpdating {
    
    func presentNetworkErrorAlertWith(retry action: @escaping (() -> Void)) {
        let alertViewModel = NetworkErrorAlertViewModel(action: { _ in
            action()
        })
        self.presentAlert(alertViewModel)
    }
    
    struct NetworkErrorAlertViewModel: AlertViewModel {
        
        init(action: @escaping ((UIAlertAction) -> ())) {
            let retryActionViewMoel = RetryActionViewModel(handler: action)
            alertActions = [retryActionViewMoel]
        }
        
        var alertController: UIAlertControllerViewModel = NetworkErrorAlertControllerViewModel()
        var alertActions: [UIAlertActionViewModel]?
        
        private struct NetworkErrorAlertControllerViewModel: UIAlertControllerViewModel {
            
            var title: String? = Texts.network_error
            var message: String? = Texts.retry_after_network_connection
            var preferredStyle: UIAlertControllerStyle = .alert
        }
        
        private struct RetryActionViewModel: UIAlertActionViewModel {
            
            init(handler: @escaping ((UIAlertAction) -> Void)) {
                self.handler = handler
            }
            
            var title: String? = Texts.retry
            var style: UIAlertActionStyle = .defaults
            var handler: ((UIAlertAction) -> Void)?
            
        }
        
    }
    
}
