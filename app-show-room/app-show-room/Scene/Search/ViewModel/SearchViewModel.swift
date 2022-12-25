//
//  SearchViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import UIKit

// MARK: - SearchViewModelInput

protocol SearchViewModelInput {
    
    var searchBarPlaceholder: String { get }
    var initialPlatformSegmentIndex: Int { get }
    
    func didTappedSearch(
        with input: String) async
    -> Output<[AppDetail], AlertViewModel>
    
    func didSelectPlatformSegement(at index: Int) -> UIImage?
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
    
    var initialPlatformSegmentIndex: Int {
        let softeware = AppSearchingConfiguration.softwareType
        switch softeware {
        case .iPhone:
            return PlatformSegment.iPhone.rawValue
        case .iPad:
            return PlatformSegment.iPad.rawValue
        case .mac:
            return PlatformSegment.mac.rawValue
        }
    }
  
    func didTappedSearch(
        with input: String)
    async -> Output<[AppDetail], AlertViewModel>
    {
        do {
            let appDetails = try await self.appSearchUsecase.searchAppDetail(
                of: input)
            if appDetails.isEmpty {
                return .failure(SearchSceneNamespace.searchFailureAlertViewModel)
            } else {
                return .success(appDetails)
            }
        } catch {
            return .failure(SearchSceneNamespace.searchFailureAlertViewModel)
        }
    }
    
    func didSelectPlatformSegement(at index: Int) -> UIImage? {
        if let softwareType = PlatformSegment(rawValue: index)?.softwareType {
            AppSearchingConfiguration.setSoftwareType(by: softwareType)
        }
        return PlatformSegment(rawValue: index)?.icon
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
        
        var icon: UIImage? {
            switch self {
            case .iPhone:
                return UIImage(named: "iPhone")
            case .iPad:
                return UIImage(named: "iPad")
            case .mac:
                return UIImage(named: "mac")
            }
        }
        
    }
    
}
