//
//  SplachCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/17.
//

import UIKit


protocol SplachCoordinatorContext: BaseCoordinatorContext {
    func showSplash(window: UIWindow)
}

extension SplachCoordinatorContext {
    func showSplash(window: UIWindow) {
        let coordinator = SplachCoordinator(window: window)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

}
