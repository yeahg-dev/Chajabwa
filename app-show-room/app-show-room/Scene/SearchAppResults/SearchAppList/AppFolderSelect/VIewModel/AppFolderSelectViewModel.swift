//
//  AppFolderSelectViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/17.
//

import Combine
import UIKit

final class AppFolderSelectViewModel: NSObject {
    
    private let appFolderUsecase = AppFolderUsecase()
    
    private var allAppFolders = [AppFolder]()
    private var appFolderCellModels = [AppFolderTableViewCellModel]()
    private let appUnit: AppUnit
    private let iconImageURL: String?
    
    // MARK: - Input
    
    private let cellDidSelected = PassthroughSubject<Void, Never>()
    
    // MARK: - Output
    
    var navigationTitle = Texts.save_to_folder
    var saveButtonTitle = Texts.save
    
    var saveButtonIsEnabled: AnyPublisher<Bool, Never> {
        return cellDidSelected.map { [unowned self] in
            return self.appFolderCellModels
                .filter{$0.isBelongedToFolder}.count }
        .flatMap {  [unowned self] selectedAppCount in
            Just(self.appFolderUsecase.canSaveAppFolder(with: selectedAppCount)) }
        .eraseToAnyPublisher()
    }
    
    init(
        appUnit: AppUnit,
        iconImageURL: String?
    ) {
        self.appUnit = appUnit
        self.iconImageURL = iconImageURL
        super.init()
    }
    
    func fetchLatestData() async {
        allAppFolders = await appFolderUsecase.readAllAppFolder()
        let selectedAppFolders = await appFolderUsecase.readAppFolders(of: appUnit)
        appFolderCellModels = allAppFolders.map{
            let isSelectedAppFolder = selectedAppFolders.contains($0)
            return AppFolderTableViewCellModel(
                appFolder: $0,
                isSelectedAppFolder: isSelectedAppFolder)}
        cellDidSelected.send(())
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        appFolderCellModels[indexPath.row].isBelongedToFolder.toggle()
        cellDidSelected.send(())
    }
   
    func saveButtonDidTapped() async -> Output<Void, AlertViewModel> {
        var selectedIndexes = [Int]()
        for (index, cellModel) in appFolderCellModels.enumerated() {
            if cellModel.isBelongedToFolder == true {
                selectedIndexes.append(index)
            }
        }
        var selectedAppFolder = [AppFolder]()
        for index in selectedIndexes {
            selectedAppFolder.append(allAppFolders[index])
        }
        do {
            _ = try await appFolderUsecase.updateAppFolder(
                of: appUnit,
                iconImageURL: iconImageURL,
                to: selectedAppFolder)
            return .success(())
        } catch {
            return .failure(SaveFailureAlertViewModel())
        }
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
