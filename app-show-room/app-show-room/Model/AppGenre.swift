//
//  AppGenre.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/12.
//

import UIKit

enum AppGenre: String, Codable {
    
    case books = "Books"
    case business = "Business"
    case developerTools = "Developer Tools"
    case education =  "Education"
    case entertainment = "Entertainment"
    case finance = "Finance"
    case foodAndDrink = "Food & Drink"
    case games = "Games"
    case graphicsAndDesign = "Graphics & Design"
    case healthAndFitness = "Health & Fitness"
    case lifeStyle = "Life Style"
    case kids = "Kids"
    case magazinesAndNewspapers = "Magazines and Newspaper"
    case medical = "Medical"
    case music = "Music"
    case navigation = "Navigation"
    case news = "News"
    case photoAndVideo = "Photo & Video"
    case productivity = "Productivity"
    case reference = "Reference"
    case safariExtension = "Safari Extension"
    case shopping = "Shopping"
    case socialNetworking = "Social Networking"
    case sports = "Sports"
    case travel = "Travel"
    case utilities = "Utilities"
    case weahter = "Weather"
    
    var symbolImage: UIImage? {
        switch self {
        case .books:
            return UIImage(systemName: "books.vertical.fill")
        case .business:
            return UIImage(systemName: "suitcase.fill")
        case .developerTools:
            return UIImage(systemName: "hammer.fill")
        case .education:
            return UIImage(systemName: "graduationcap.fill")
        case .entertainment:
            return UIImage(systemName: "face.smiling.fill")
        case .finance:
            return UIImage(systemName: "banknote.fill")
        case .foodAndDrink:
            return UIImage(systemName: "fork.knife")
        case .games:
            return UIImage(systemName: "gamecontroller.fill")
        case .graphicsAndDesign:
            return UIImage(systemName: "lasso.and.sparkles")
        case .healthAndFitness:
            return UIImage(systemName: "bicycle")
        case .lifeStyle:
            return UIImage(systemName: "house.fill")
        case .kids:
            return UIImage(systemName: "face.dashed.fill")
        case .magazinesAndNewspapers:
            return UIImage(systemName: "magazine.fill")
        case .medical:
            return UIImage(systemName: "staroflife.circle.fill")
        case .music:
            return UIImage(systemName: "music.quarternote.3")
        case .navigation:
            return UIImage(systemName: "location.circle.fill")
        case .news:
            return UIImage(systemName: "antenna.radiowaves.left.and.right")
        case .photoAndVideo:
            return UIImage(systemName: "camera.fill")
        case .productivity:
            return UIImage(systemName: "paperplane.fill")
        case .reference:
            return UIImage(systemName: "magnifyingglass")
        case .safariExtension:
            return UIImage(systemName: "safari.fill")
        case .shopping:
            return UIImage(systemName: "cart.fill")
        case .socialNetworking:
            return UIImage(systemName: "message.fill")
        case .sports:
            return UIImage(systemName: "sportscourt.fill")
        case .travel:
            return UIImage(systemName: "binoculars.fill")
        case .utilities:
            return UIImage(systemName: "calendar.badge.clock")
        case .weahter:
            return UIImage(systemName: "cloud.sun.fill")
        }
    }
    
}
