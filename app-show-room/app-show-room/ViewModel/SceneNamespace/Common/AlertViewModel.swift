//
//  AlertViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import UIKit

protocol AlertViewModel {
    
    var alertController: UIAlertControllerViewModel  { get }
    var alertAction: UIAlertActionViewModel?  { get }
    
}

protocol UIAlertControllerViewModel {
    
    var title: String? { get }
    var message: String? { get }
    var preferredStyle: UIAlertController.Style { get }
}

protocol UIAlertActionViewModel {
    
    var title: String? { get }
    var style: UIAlertAction.Style { get }
}
