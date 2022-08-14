//
//  AppSearchUsecase.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import Foundation

struct AppSearchUsecase {
    
    private var repository: AppDetailRepository
    
    init(repository: AppDetailRepository = ItunesAppDetailRepository()) {
        self.repository = repository
    }
    
    func searchApp(
        of id: String,
        completion: ((Result<AppDetail, Error>) -> Void)?) {
            guard let id = Int(id) else {
                completion?(.failure(AppSearchUsecaseError.invalidInputType))
                return
            }
            
            self.repository.fetchAppDetail(
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

