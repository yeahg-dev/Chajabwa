//
//  SearchViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import Foundation

// MARK: - SearchViewModelInput

protocol SearchViewModelInput {
    
    var searchBarPlaceholder: String { get }
    
    func didTappedSearch(
        with input: String) async
    -> Output<[AppDetail], AlertViewModel>
}

enum Output<Success, Failure> {
    
    case success(Success)
    case failure(Failure)
}


// MARK: - SearchViewModel

struct SearchViewModel {
    
    private let appSearchUsecase: AppSearchUsecase
    
    init(appSearchUsecase: AppSearchUsecase) {
        self.appSearchUsecase = appSearchUsecase
    }
    
}
// MARK: - SearchViewModelInput

extension SearchViewModel: SearchViewModelInput {
    
    var searchBarPlaceholder: String {
        return SearchSceneNamespace.searchBarPlaceholder
    }
    
    func didTappedSearch(with input: String) async -> Output<[AppDetail], AlertViewModel> {
        do {
            let appDetails = try await self.appSearchUsecase.searchAppDetail(of: input)
            if appDetails.isEmpty {
                return .failure(SearchSceneNamespace.searchFailureAlertViewModel)
            } else {
                return .success(appDetails)
            }
        } catch {
            return .failure(SearchSceneNamespace.searchFailureAlertViewModel)
        }
    }
 
}
