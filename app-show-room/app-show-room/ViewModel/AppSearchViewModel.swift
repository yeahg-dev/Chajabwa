//
//  AppSearchViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import Foundation

// MARK: - AppSearchViewModelInput

protocol AppSearchViewModelInput {
    
    func didTappedSearch(with input: String)
}

// MARK: - AppSearchViewModelOutput

protocol AppSearchViewModelOutput {
    
    var searchBarPlaceholder: Observable<String> { get }
    var searchResult: Observable<AppDetail?> { get }
    var searchFailureAlert: Observable<AlertViewModel?> { get }
}

// MARK: - AppSearchViewModel

struct AppSearchViewModel: AppSearchViewModelOutput {

    private let appSearchUsecase: AppSearchUsecase
    
    init(appSearchUsecase: AppSearchUsecase) {
        self.appSearchUsecase = appSearchUsecase
    }
    
    // MARK: - Output
    var searchBarPlaceholder = Observable(AppSearchSceneNamespace.searchBarPlaceholder)
    var searchResult = Observable<AppDetail?>(.none)
    var searchFailureAlert = Observable<AlertViewModel?>(.none)
    
}

// MARK: - Input

extension AppSearchViewModel: AppSearchViewModelInput {
    
    func didTappedSearch(with input: String) {
        self.appSearchUsecase.searchApp(
            of: input) { result in
                switch result {
                case .success(let appDetail):
                    self.searchResult.value = appDetail
                case.failure(let error):
                    self.handleSearchError(error)
                }
            }
    }
    
    private func handleSearchError(_ error: Error) {
        if let appSearchUseacseError = error as? AppSearchUsecaseError,
           appSearchUseacseError == AppSearchUsecaseError.invalidInputType {
            self.searchFailureAlert.value = AppSearchSceneNamespace.invalidInputAlertViewModel
        } else {
            self.searchFailureAlert.value = AppSearchSceneNamespace.searchFailureAlertViewModel
        }
    }
    
}
