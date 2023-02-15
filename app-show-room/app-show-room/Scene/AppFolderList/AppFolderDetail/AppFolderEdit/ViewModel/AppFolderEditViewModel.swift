//
//  AppFolderEditViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/01/23.
//

import Combine
import Foundation

class AppFolderEditViewModel {
    
    private let appFolderUsecase = AppFolderUsecase()
    
    private var appFolder: AppFolder!
    
    private var cancellables = Set<AnyCancellable>()
    
    init(appFolderIdentifier: String) {
        Task {
            self.appFolder = await fetchLatedstAppFolder(appFolderIdentifier)
        }
    }
    
    struct Input {
        
        let appFolderNameDidChange: AnyPublisher<String?, Never>
        let appFolderDescriptionDidChange: AnyPublisher<String?, Never>
        let saveButtonDidTapped: AnyPublisher<AppFolderData, Never>
        let closeButtonDidTapped: AnyPublisher<Void, Never>
        
    }
    
    struct Output {
        
        let folderNameTextFieldPlaceholder = Text.folder_name_condition
        let doneButtonTitle = Text.save
        let appFolderName: String
        let appFolderDescription: String?
        let navigationBarTitle: String
        let doneButtonIsEnabled: AnyPublisher<Bool, Never>
        let alertViewModel: AnyPublisher<AlertViewModel, Never>
        let presentingViewWillUpdate: AnyPublisher<Void, Never>
        let dismiss: AnyPublisher<Void, Never>
        
    }
    
    func transform(_ input: Input) -> Output {
        let doneButtonIsEnabled = input.appFolderNameDidChange
            .map { name in
                self.appFolderUsecase.validateAppFolderName(name)
            }
            .eraseToAnyPublisher()
        
        let alertViewModel = PassthroughSubject<AlertViewModel, Never>()
        let dismiss = PassthroughSubject<Void, Never>()
        let presentingViewWillUpdate = PassthroughSubject<Void, Never>()
        
        input.saveButtonDidTapped
            .sink { [unowned self] data in
                Task {
                    do {
                        try await self.appFolderUsecase.updateAppFolder(
                            self.appFolder,
                            name: data.name,
                            description: data.descritpion)
                        presentingViewWillUpdate.send(())
                        dismiss.send(())
                    } catch {
                        alertViewModel.send(
                            AppFolderSaveFailureAlertViewModel())
                    }
                }
            }.store(in: &cancellables)
        

        return Output(
            appFolderName: appFolder.name,
            appFolderDescription: appFolder.description,
            navigationBarTitle: Text.app_folder_eidt,
            doneButtonIsEnabled: doneButtonIsEnabled,
            alertViewModel: alertViewModel.eraseToAnyPublisher(),
            presentingViewWillUpdate: presentingViewWillUpdate.eraseToAnyPublisher(),
            dismiss: dismiss.eraseToAnyPublisher())
    }
    
    private func fetchLatedstAppFolder(_ identifier: String) async -> AppFolder {
        do {
            return try await appFolderUsecase.readAppFolder(identifer: identifier)
        } catch {
            return AppFolder.placeholder
        }
    }
    
}

extension AppFolderEditViewModel {
    
    struct AppFolderData {
        
        let name: String
        let descritpion: String
        
    }
    
}
