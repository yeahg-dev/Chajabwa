//
//  SearchCoordinator.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/25.
//

import UIKit

final class SearchCoordinator: NSObject, Coordinator {
    
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchKeywordRepository = RealmSearchKeywordRepository()
        let appSearchUseacase = AppSearchUsecase(
            searchKeywordRepository: searchKeywordRepository)
        let seachViewModel = SearchViewModel(appSearchUsecase: appSearchUseacase)
        let searchVC = SearchViewController(searchViewModel: seachViewModel)
        searchVC.coordinator = self
        
        navigationController.pushViewController(searchVC, animated: false)
    }
    
}

extension SearchCoordinator {
    
    func pushAppFolderListView() {
        let appFolderCoordintor = AppFolderListCoordinator(
            navigationController: navigationController)
        appFolderCoordintor.parentCoordinator = self
        childCoordinator.append(appFolderCoordintor)
        appFolderCoordintor.start()
    }
    
    func pushAppDetailView(_ appDetail: AppDetail) {
        let appDetailCoordinator = AppDetailCoordinator(
            appDetail: appDetail,
            navigationController: navigationController)
        appDetailCoordinator.parentCoordinator = self
        childCoordinator.append(appDetailCoordinator)
        appDetailCoordinator.start()
    }
    
    func pushAppFolderSelectView(of appUnit: AppUnit, iconImageURL: String?) {
     let appFoldeSelectVC = AppFolderSelectViewController(
        appUnit: appUnit,
        iconImageURL: iconImageURL)
        navigationController.pushViewController(appFoldeSelectVC, animated: true)
    }
    
    func presentSettingView() -> SettingViewController {
        let settinVC = SettingViewController()
        navigationController.present(settinVC, animated: true)
        return settinVC
    }
    
}
