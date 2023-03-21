//
//  AppOrganizer.swift
//  app-show-room
//
//  Created by Moon Yeji on 2023/03/21.
//

import Foundation

final class AppOrganizer {

    func prepare() {
        downloadCountryCodes()
    }
    
    private func downloadCountryCodes() {
        CountryCodeAPIService().fetchCountryCodes()
    }
    
}

extension Notification.Name {
    
    static let prepareStart = Notification.Name("prepareStart")
    static let prepareEndWithError = Notification.Name("prepareEndWithError")
    static let prepareEndWithSuccess = Notification.Name("prepareEndWithSuccess")
    
}

protocol AppOrganizerDelegate {
    
    func notifyPrepareStart(with: Progress)
    
    func notifyEndWithError()
    
    func notifyEndWithSuccess()
    
}

protocol AppStarter {
    
    func addObserver()
    
    func prepareDidStart()
    
    func prepareEndWithError()
    
    func prepareEndWithSuccess()
}
