//
//  MainCoordinator.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit


class MainCoordinator: Coordinator {
    
    var delegate: CoordinatorDidFinishDelegate?
    
    var tabBarController: TabbarViewController
    
    var presenter: UINavigationController
    
    var tabBarItems: [TabBarItem] = TabBarItem.allCases
    
    var childCoordinators: [Coordinator]
    
    
    init(tabbarController: TabbarViewController) {
        self.tabBarController = tabbarController
        self.presenter = UINavigationController()
        self.childCoordinators = []
    }
    
    
    func start(animated: Bool = true) {
        let viewControllers = tabBarItems.map { getTabController(item: $0) }
        tabBarController.configure(with: viewControllers)
        tabBarController.setViewControllers(viewControllers, animated: true)
    }
    
    /// tabBarItem 설정
    func getTabController(item: TabBarItem) -> UINavigationController {
        let navigationController = UINavigationController()
        
        let tabItem = UITabBarItem(title: item.title, image: item.image, selectedImage: item.selectedImage)
        tabItem.tag = item.rawValue
        navigationController.tabBarItem = tabItem
        
        let coordinator = item.getCoordinator(presenter: navigationController)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start(animated: true)
        return navigationController
    }
}
