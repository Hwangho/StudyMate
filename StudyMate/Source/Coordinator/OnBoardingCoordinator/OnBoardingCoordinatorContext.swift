//
//  OnBoardingCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit


protocol OnBoardingCoordinatorContext: BaseCoordinatorContext {
    func firstStartOnBoarding(present: UINavigationController)
}


extension OnBoardingCoordinatorContext {
    func firstStartOnBoarding(present: UINavigationController) {
        let coordinator = OnBoardingCoordinator(present: present)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
