//
//  AlertViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import UIKit

protocol AlertViewModel {
    
    var alertController: UIAlertControllerViewModel  { get }
    var alertActions: [UIAlertActionViewModel]?  { get }
    
}

protocol UIAlertControllerViewModel {
    
    var title: String? { get }
    var message: String? { get }
    var preferredStyle: UIAlertControllerStyle { get }
}

protocol UIAlertActionViewModel {
    
    var title: String? { get }
    var style: UIAlertActionStyle { get }
}

enum UIAlertControllerStyle {
    
    case alert
    case actionSheet
    
    var value: UIAlertController.Style {
        switch self {
        case .alert:
            return UIAlertController.Style.alert
        case .actionSheet:
            return UIAlertController.Style.actionSheet
        }
    }
}

enum UIAlertActionStyle {
    
    case defaults
    case cancel
    case destructive
    
    var value: UIAlertAction.Style {
        switch self {
        case .defaults:
            return UIAlertAction.Style.default
        case .cancel:
            return UIAlertAction.Style.cancel
        case .destructive:
            return UIAlertAction.Style.destructive
        }
    }
}
