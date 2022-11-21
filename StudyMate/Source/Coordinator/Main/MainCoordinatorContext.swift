//
//  MainCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit


protocol MainCoordinatorContext: BaseCoordinatorContext {
    func firstStartMain(tabbar: TabbarViewController)
}

extension MainCoordinatorContext {
    
    func firstStartMain(tabbar: TabbarViewController) {
        let coordinator = MainCoordinator(tabbarController: tabbar)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
}
