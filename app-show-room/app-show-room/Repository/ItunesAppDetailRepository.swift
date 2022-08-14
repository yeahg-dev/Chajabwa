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
            guard let appDetail = try? result.get().toAppDetail() else {
                completion?(.failure(DTOError.invalidTransform))
                return
            }
            
            switch result {
            case .success(_):
                completion?(.success(appDetail))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
}
