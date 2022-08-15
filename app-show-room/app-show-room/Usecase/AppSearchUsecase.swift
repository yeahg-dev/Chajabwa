//
//  AppSearchUsecase.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import Foundation

struct AppSearchUsecase {
    
    private let appDetailRepository: AppDetailRepository
    
    init(appDetailRepository: AppDetailRepository = ItunesAppDetailRepository()) {
        self.appDetailRepository = appDetailRepository
    }
    
    func searchApp(
        of id: String,
        completion: ((Result<AppDetail, Error>) -> Void)?) {
            guard let id = Int(id) else {
                completion?(.failure(AppSearchUsecaseError.invalidInputType))
                return
            }
            
            self.appDetailRepository.fetchAppDetail(
                of: id) { result in
                    switch result {
                    case .success(let appDetail):
                        completion?(.success(appDetail))
                    case .failure(let error):
                        completion?(.failure(error))
                    }
                }
        }
    
}

enum AppSearchUsecaseError: Error {
    
    case invalidInputType
}

