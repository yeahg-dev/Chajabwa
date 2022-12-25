//
//  SettingViewModel.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/25.
//

import UIKit

struct SettingViewModel {
    
    var navigationBarTitle: String = "설정"
    var platformTitleLabelText: String = "플랫폼"
    var countryTitleLabelText: String = "국가"
    
    var platformSegmentIndex: Int {
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
    
    var selectedCountryIndex: Int {
        let currentCountry = AppSearchingConfiguration.countryISOCode
        return Country.list.firstIndex { $0 == currentCountry } ?? 0
    }
    
    func didSelectPlatformSegement(at index: Int) {
        if let softwareType = PlatformSegment(rawValue: index)?.softwareType {
            AppSearchingConfiguration.setSoftwareType(by: softwareType)
        }
    }
    
    func didSelectCountry(at row: Int) {
        let country = Country.list[row]
        AppSearchingConfiguration.setCountry(by: country)
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
