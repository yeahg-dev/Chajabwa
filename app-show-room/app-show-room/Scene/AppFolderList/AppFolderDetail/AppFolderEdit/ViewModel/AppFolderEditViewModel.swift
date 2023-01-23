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
    
    private let appFolder: AppFolder
    
    private var cancellables = Set<AnyCancellable>()
    
    init(appFolder: AppFolder) {
        self.appFolder = appFolder
    }
    
    // Input
    struct Input {
        
        let appFolderNameDidChange: AnyPublisher<String?, Never>
        let appFolderDescriptionDidChange: AnyPublisher<String?, Never>
        let saveButtonDidTapped: AnyPublisher<AppFolderData, Never>
        let closeButtonDidTapped: AnyPublisher<Void, Never>
        
    }
    
    struct Output {
        
        let appFolderName: String
        let appFolderDescription: String?
        let navigationBarTitle: String
        let doneButtonIsEnabled: AnyPublisher<Bool, Never>
        let dismiss: AnyPublisher<Void, Never>
        
    }
    
    // TODO: - deleteConfirmAlert, AlertViewModel에 handelr 추가
    
    func transform(_ input: Input) -> Output {
        let doneButtonIsEnabled = input.appFolderNameDidChange
            .map { name in
                self.appFolderUsecase.validateAppFolderName(name)
            }
            .eraseToAnyPublisher()
        
        let dismiss = PassthroughSubject<Void, Never>()
        input.saveButtonDidTapped
            .sink { data in
                Task {
                    do {
                        try await self.appFolderUsecase.updateAppFolder(
                            self.appFolder,
                            name: data.name,
                            description: data.descritpion)
                        dismiss.send(())
                    } catch {
                        // TODO: - Alert send
                    }
                }
            }.store(in: &cancellables)
        

        return Output(
            appFolderName: appFolder.name,
            appFolderDescription: appFolder.description,
            navigationBarTitle: Text.appFolderEdit.rawValue,
            doneButtonIsEnabled: doneButtonIsEnabled,
            dismiss: dismiss.eraseToAnyPublisher())
    }
    
}

extension AppFolderEditViewModel {
    
    struct AppFolderData {
        
        let name: String
        let descritpion: String
        
    }
    
}
