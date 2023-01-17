//
//  AppFolderSelectViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/17.
//

import UIKit

final class AppFolderSelectViewModel: NSObject {
    
    var navigationTitle = "폴더에 저장하기"
    var saveButtonTitle = "저장"
    
    private let appFolderUsecase = AppFolderUsecase()
    private var appFolders = [AppFolder]()
    private var appFolderCellModels = [AppFolderTableViewCellModel]()
    private let appUnit: AppUnit
    private let iconImageURL: String?
    
    init(appUnit: AppUnit, iconImageURL: String?) {
        self.appUnit = appUnit
        self.iconImageURL = iconImageURL
        super.init()
    }
    
    func fetchLatestData() async {
        appFolders = await appFolderUsecase.readAllAppFolder()
        let selectedAppFolder = await appFolderUsecase.readAppFolders(of: appUnit)
        appFolderCellModels = appFolders.map{
            let isSelectedAppFolder = selectedAppFolder.contains($0)
            return AppFolderTableViewCellModel(
                appFolder: $0,
                isSelectedAppFolder: isSelectedAppFolder)}
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        appFolderCellModels[indexPath.row].isBelongedToFolder.toggle()
    }
   
    func saveButtonDidTapped() async throws {
        var selectedIndexes = [Int]()
        for (index, cellModel) in appFolderCellModels.enumerated() {
            if cellModel.isBelongedToFolder == true {
                selectedIndexes.append(index)
            }
        }
        var selectedAppFolder = [AppFolder]()
        for index in selectedIndexes {
            selectedAppFolder.append(appFolders[index])
        }
        
        try await appFolderUsecase.updateAppFolder(
            of: appUnit,
            iconImageURL: iconImageURL,
            to: selectedAppFolder)
    }
    
}

// MARK: - UITableViewDataSource

extension AppFolderSelectViewModel: UITableViewDataSource {
    
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
