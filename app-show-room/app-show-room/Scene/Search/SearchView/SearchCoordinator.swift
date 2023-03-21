//
//  SearchCoordinator.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/25.
//

import Combine
import UIKit

final class SearchCoordinator: NSObject, Coordinator {
    
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController!
    
    init(rootViewController: UINavigationController) {
        self.navigationController = rootViewController
    }
    
    func start() {
        let searchKeywordRepository = RealmSearchKeywordRepository()
        let appSearchUseacase = AppSearchUsecase(
            searchKeywordRepository: searchKeywordRepository)
        let seachViewModel = SearchViewModel(appSearchUsecase: appSearchUseacase)
        let searchVC = SearchViewController(searchViewModel: seachViewModel)
        searchVC.coordinator = self
        navigationController.modalPresentationStyle = .fullScreen
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
        let appFolderSelectCoordniator = AppFolderSelectCoordinator(
            appUnit: appUnit,
            appIconImageURL: iconImageURL,
            navigationController: navigationController)
        appFolderSelectCoordniator.parentCoordintaor = self
        childCoordinator.append(appFolderSelectCoordniator)
        appFolderSelectCoordniator.start()
    }
    
    func presentSettingView() -> SettingViewController {
        let settinVC = SettingViewController()
        navigationController.present(settinVC, animated: true)
        return settinVC
    }
    
}
