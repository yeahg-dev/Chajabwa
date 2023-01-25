//
//  AppDetailCoordinator.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/26.
//

import UIKit

final class AppDetailCoordinator: Coordinator {
    
    var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    private let appDetail: AppDetail
    
    init(appDetail: AppDetail, navigationController: UINavigationController) {
        self.appDetail = appDetail
        self.navigationController = navigationController
    }
    
    func start() {
        let appDetailVC = AppDetailViewController(
            appDetailViewModel: AppDetailViewModel(app: appDetail))
        appDetailVC.coordinator = self
        navigationController.pushViewController(appDetailVC, animated: true)
    }
    
}

extension AppDetailCoordinator {
    
    func pushAppFolderSelectView(appUnit: AppUnit, appIconImageURL: String?) {
        let view = AppFolderSelectViewController(
           appUnit: appUnit,
           iconImageURL: appIconImageURL)
        navigationController.pushViewController(view, animated: true)
    }
    
    func presentScreenshotGallery(screenshotURLs: [String]?) {
        let screenshotGalleryViewModel = ScreenshotGalleryViewModel(
            screenshotURLs: screenshotURLs)
        let screenshotGalleryVC = ScreenshotGalleryViewController(
            viewModel: screenshotGalleryViewModel)
        screenshotGalleryVC.modalPresentationStyle = .overFullScreen
        navigationController.present(screenshotGalleryVC, animated: true)
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
    
}
