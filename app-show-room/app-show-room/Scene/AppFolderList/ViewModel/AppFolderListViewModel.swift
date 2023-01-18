//
//  AppFolderListViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/18.
//

import Combine
import UIKit

final class AppFolderListViewModel: NSObject {
    
    private let appFolderUsecase = AppFolderUsecase()
    
    private var appFolders = [AppFolder]()
    private var appFolderCellModels = [AppFolderTableViewCellModel]()
    
    struct Input {
        
        let appFolderCellDidSelected: AnyPublisher<IndexPath, Never>
        
    }
    
    struct Output {
        
        let navigationTitle = "폴더 리스트"
        let slectedAppFolder: AnyPublisher<AppFolder?, Never>
        
    }
    
    func transform(input: Input) -> Output {
        let selectedAppFolder = input.appFolderCellDidSelected
            .map{$0.row}
            .map{ self.appFolders[safe: $0] }
            .eraseToAnyPublisher()
        
        return Output(slectedAppFolder: selectedAppFolder)
    }
    
    func fetchLatestData() async {
        appFolders = await appFolderUsecase.readAllAppFolder()
        appFolderCellModels = appFolders.map{
            AppFolderTableViewCellModel(appFolder: $0, isSelectedAppFolder: false)}
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
