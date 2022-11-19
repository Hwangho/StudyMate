//
//  TabBarItem.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit


enum TabBarItem: Int, CaseIterable {
    case home
//    case shop
//    case friends
    case myInfo
    
    var title: String {
        switch self {
        case .home: return "홈"
//        case .shop: return "새싹샵"
//        case .friends: return "새싹친구"
        case .myInfo: return "내정보"
        }
    }
    
    var image: UIImage {
        switch self {
        case .home: return UIImage(named: "home_deselect")!
//        case .shop: return UIImage(systemName: "text.book.closed")!
//        case .friends: return UIImage(systemName: "text.book.closed")!
        case .myInfo: return UIImage(named: "person_deselect")!
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .home: return UIImage(named: "home_select")!
//        case .shop: return UIImage(systemName: "text.book.closed")!
//        case .friends: return UIImage(systemName: "text.book.closed")!
        case .myInfo: return UIImage(named: "person_select")!
        }
    }
    
    func getCoordinator(presenter: UINavigationController) -> Coordinator {
        switch self {
        case .home: return HomeCoordinator(presenter: presenter)
//        case .shop: return
//        case .friends: return
        case .myInfo: return MyPageCoordinator(presenter: presenter)
        }
    }
    
}
