//
//  AppFolderListCoordinator.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/25.
//

import UIKit

final class AppFolderListCoordinator: Coordinator {
    
    var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let appFolderListVC = AppFolderListViewController()
        appFolderListVC.coordinator = self
        navigationController.pushViewController(appFolderListVC, animated: true)
    }

}

extension AppFolderListCoordinator {
   
    func presentAppFolderCreatorView() -> AppFolderCreatorViewController {
        let appFolderCreatorVC = AppFolderCreatorViewController()
        navigationController.present(appFolderCreatorVC, animated: true)
        return appFolderCreatorVC
    }
    
    func pushAppFolderDetailView(_ appFolder: AppFolder?) {
        guard let appFolder else {
            print("appFolder does not exist")
            return
        }
        
        let appFolderDetailCoordinator = AppFolderDetailCoordinator(
            appFolder: appFolder,
            navigationController: navigationController)
        childCoordinator.append(appFolderDetailCoordinator)
        appFolderDetailCoordinator.parentCoordintaor = self
        appFolderDetailCoordinator.start()
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
    
}
