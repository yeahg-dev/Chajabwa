//
//  Coordinator.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/25.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var childCoordinator: [Coordinator] { get set }
    var navigationController: UINavigationController! { get set }
    
    func start()
    
}

extension Coordinator {
    
    func childDidFinish(_ child: Coordinator){
        self.childCoordinator = childCoordinator.filter{ child !== $0 }
    }
    
}
