//
//  AppFolderCreatorViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/16.
//

import Combine
import Foundation

struct AppFolderCreatorViewModel {
    
    private let appFolderUsecase = AppFolderUsecase()
    
    // MARK: - Input
    
    private let appFolderName: AnyPublisher<String?, Never>
    private let appFolderDescription: AnyPublisher<String?, Never>
    
    init(
        appFolderName: AnyPublisher<String?, Never>,
        appFolderDescription: AnyPublisher<String?, Never>)
    {
        self.appFolderName = appFolderName
        self.appFolderDescription = appFolderDescription
    }
    
    // MARK: - Output
    
    let folderNameTextFieldPlaceholder = "폴더 이름 (2글자 이상)"
    let doneButtonTitle = "완료"
    
    var doneButtonIsEnabled: AnyPublisher<Bool, Never> {
        return appFolderName.flatMap({ name in
            let isEnabled = appFolderUsecase.validateAppFolderName(name)
            return Just(isEnabled)
        })
        .eraseToAnyPublisher()
    }
    
    func doneButtonDidTapped(name: String?, description: String?)
    async -> Output<AppFolder, AlertViewModel>
    {
        guard let name else {
            return .failure(AppFolderCreatorAlertViewModel.AppFolderCreationFailureAlertViewModel())
        }
        
        do {
            let appFolder: AppFolder = try await appFolderUsecase.createEmptyAppFolder(
                name: name,
                description: description)
            return .success(appFolder)
        } catch {
            return .failure(AppFolderCreatorAlertViewModel.AppFolderCreationFailureAlertViewModel())
        }
    }
    
}
