//
//  HomeCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit


protocol HomeCoordinatorContext: BaseCoordinatorContext {
    func firstStartHome(prsenter: UINavigationController)
}


extension HomeCoordinatorContext {
    func firstStartHome(prsenter: UINavigationController) {
        let coordinator = HomeCoordinator(presenter: prsenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
