//
//  AppFolderSelectCoordinator.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/26.
//

import UIKit

final class AppFolderSelectCoordinator: Coordinator {
    
    var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController!
    weak var parentCoordintaor: Coordinator?
    
    private let appUnit: AppUnit
    private let appIconImageURL: String?
    
    init(
        appUnit: AppUnit,
        appIconImageURL: String? ,
        navigationController: UINavigationController) {
            self.appUnit = appUnit
            self.appIconImageURL = appIconImageURL
            self.navigationController = navigationController
        }
    
    func start() {
        let appFolderSelectVC = AppFolderSelectViewController(
            appUnit: appUnit,
            iconImageURL: appIconImageURL)
        navigationController.pushViewController(appFolderSelectVC, animated: true)
    }
    
}

extension AppFolderSelectCoordinator {
    
    func presentAppFolderCreatorView() -> AppFolderCreatorViewController {
        let appFolderCreatorVC = AppFolderCreatorViewController()
        navigationController.present(appFolderCreatorVC, animated: true)
        return appFolderCreatorVC
    }
    
    func didFinish() {
        parentCoordintaor?.childDidFinish(self)
    }
    
}
