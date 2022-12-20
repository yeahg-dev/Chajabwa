//
//  SearchViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import Foundation

// MARK: - SearchViewModelInput

protocol SearchViewModelInput {
    
    func didTappedSearch(with input: String)
}

// MARK: - SearchViewModelOutput

protocol AppSearchViewModelOutput {
    
    var searchBarPlaceholder: Observable<String> { get }
    var searchResult: Observable<AppDetail?> { get }
    var searchFailureAlert: Observable<AlertViewModel?> { get }
}

// MARK: - SearchViewModel

struct SearchViewModel: AppSearchViewModelOutput {
    
    private let appSearchUsecase: AppSearchUsecase
    
    init(appSearchUsecase: AppSearchUsecase) {
        self.appSearchUsecase = appSearchUsecase
    }
    
    // MARK: - Output
    var searchBarPlaceholder = Observable(SearchSceneNamespace.searchBarPlaceholder)
    var searchResult = Observable<AppDetail?>(.none)
    var searchFailureAlert = Observable<AlertViewModel?>(.none)
    
}

// MARK: - Input

extension SearchViewModel: SearchViewModelInput {
    
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
            self.searchFailureAlert.value = SearchSceneNamespace.searchFailureAlertViewModel
        }
    }
    
}
