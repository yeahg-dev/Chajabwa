//
//  ItunesAppDetailRepository.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/14.
//

import Foundation

protocol AppDetailRepository {
    
    func fetchAppDetail(of id: Int, completion: ((Result<AppDetail, Error>) -> Void)?)
    
}

struct ItunesAppDetailRepository: AppDetailRepository {
    
    private var service: iTunesAPIService
    
    init(service: iTunesAPIService = iTunesAPIService()) {
        self.service = service
    }
    
    func fetchAppDetail(of id: Int, completion: ((Result<AppDetail, Error>) -> Void)?) {
        let lookupRequest = AppLookupAPIRequest(appID: id)
        self.service.execute(lookupRequest) { result in
            switch result {
            case .success(let appResponse):
                guard let result = appResponse.results.first else {
                    completion?(.failure(AppDetailRepositoryError.nonExistAppDetail))
                    return
                }
                
                guard let appDetail = result.toAppDetail() else {
                    completion?(.failure(DTOError.invalidTransform))
                    return
                }
                
                completion?(.success(appDetail))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
}

enum AppDetailRepositoryError: Error {
    
    case nonExistAppDetail
}
