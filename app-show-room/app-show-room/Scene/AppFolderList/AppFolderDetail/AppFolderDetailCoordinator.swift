//
//  AppFolderDetailCoordinator.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/25.
//

import UIKit

final class AppFolderDetailCoordinator: Coordinator {
    
    var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordintaor: Coordinator?
    
    private let appFolder: AppFolder
    
    init(appFolder: AppFolder, navigationController: UINavigationController) {
        self.appFolder = appFolder
        self.navigationController = navigationController
    }
    
    func start() {
        let appFolderDetailVC = AppFolderDetailViewController(appFolder: appFolder)
        appFolderDetailVC.coordinator = self
        navigationController.pushViewController(appFolderDetailVC, animated: true)
    }
    
}


extension AppFolderDetailCoordinator {
    
    func presentAppFolderEditView(appFolder: AppFolder) -> AppFolderEditViewController {
        let appFolderEditVC = AppFolderEditViewController(
            appFolderIdentifier: appFolder.identifier)
        navigationController.present(appFolderEditVC, animated: true)
        return appFolderEditVC
    }
    
    func pushAppDetailView(of appDetail: AppDetail?) {
        guard let appDetail else {
            return
        }
        let appDetailCoordinator = AppDetailCoordinator(
            appDetail: appDetail,
            navigationController: navigationController)
        appDetailCoordinator.parentCoordinator = self
        childCoordinator.append(appDetailCoordinator)
        appDetailCoordinator.start()
    }
    
    func popToSearchView() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func didFinish() {
        parentCoordintaor?.childDidFinish(self)
    }

}
