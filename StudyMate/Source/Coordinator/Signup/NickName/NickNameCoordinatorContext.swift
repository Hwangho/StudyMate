//
//  NickNameCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/10.
//

import UIKit

protocol NickNameCoordinatorContext: BaseCoordinatorContext {
    func startNickName()
    func firstStartNickName(present: UINavigationController)
}


extension CertificationCoordinatorContext {
    func startNickName() {
        let coordinator = NickNameCoordinator(present: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func firstStartNickName(present: UINavigationController) {
        let coordinator = NickNameCoordinator(present: present)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
