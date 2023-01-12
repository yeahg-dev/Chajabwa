//
//  SearchViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import UIKit

// MARK: - SearchViewModelInput

protocol SearchViewModelInput {
    
    var navigationItemTitle: String { get }
    var searchBarPlaceholder: String { get }
    var platformType: SoftwareType  { get }
    var countryFlag: String { get }
    var countryName: String { get }
    
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

    var navigationItemTitle: String { SearchAlertViewModel.navigationTitle }
    
    var searchBarPlaceholder: String {
        return SearchAlertViewModel.searchBarPlaceholder
    }
    
    var platformType: SoftwareType {
        return AppSearchingConfiguration.softwareType
    }
    
    var countryFlag: String {
        return AppSearchingConfiguration.countryISOCode.flag
    }
    
    var countryName: String {
        return AppSearchingConfiguration.countryISOCode.name
    }
    
  
    func didTappedSearch(
        with input: String)
    async -> Output<[AppDetail], AlertViewModel>
    {
        do {
            let appDetails = try await self.appSearchUsecase.searchAppDetail(
                of: input)
            if appDetails.isEmpty {
                return .failure(SearchAlertViewModel.EmptyResultAlertViewModel())
            } else {
                return .success(appDetails)
            }
        } catch {
            return .failure(SearchAlertViewModel.SearchFailureAlertViewModel())
        }
    }
    
    enum PlatformSegment: Int {
        
        case iPhone = 0
        case iPad = 1
        case mac = 2
        
        var softwareType: SoftwareType {
            switch self {
            case .iPhone:
                return SoftwareType.iPhone
            case .iPad:
                return SoftwareType.iPad
            case .mac:
                return SoftwareType.mac
            }
        }
        
    }
}
