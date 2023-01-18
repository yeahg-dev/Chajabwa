//
//  AppFolderListViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/18.
//

import UIKit

final class AppFolderListViewModel: NSObject {
    
    private let appFolderUsecase = AppFolderUsecase()
    
    private var appFolders = [AppFolder]()
    private var appFolderCellModels = [AppFolderTableViewCellModel]()
    
    let navigationTitle = "폴더 리스트"
    
    func fetchLatestData() async {
        appFolders = await appFolderUsecase.readAllAppFolder()
        appFolderCellModels = appFolders.map{
            AppFolderTableViewCellModel(appFolder: $0, isSelectedAppFolder: false)}
    }
    
    func appFolderCellDidSelected(at indexPath: IndexPath) -> AppFolder? {
        return appFolders[safe: indexPath.row]
    }
    
}

extension AppFolderListViewModel: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
    -> Int
    {
        return appFolderCellModels.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withClass: AppFolderTableViewCell.self,
            for: indexPath)
        guard let cellModel = appFolderCellModels[safe: indexPath.row] else {
            return cell
        }
        cell.bind(cellModel)
        return cell
    }
    
}
