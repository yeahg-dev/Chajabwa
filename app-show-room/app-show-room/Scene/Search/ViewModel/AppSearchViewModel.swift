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
        Task {
            do {
                let appDetails = try await self.appSearchUsecase.searchAppDetail(of: input)
                if let appDetail = appDetails.first {
                    searchResult.value = appDetail
                } else {
                    throw AppDetailRepositoryError.nonExistAppDetail
                }
            } catch {
                handleSearchError(error)
            }
        }
    }
    
    private func handleSearchError(_ error: Error) {
        // TODO: - 에러 핸들링 케이스 추가
        if error is AppDetailRepositoryError {
            self.searchFailureAlert.value = AppSearchSceneNamespace.searchFailureAlertViewModel
        }
    }
    
}
