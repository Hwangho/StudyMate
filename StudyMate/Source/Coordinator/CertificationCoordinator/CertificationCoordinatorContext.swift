//
//  CertificationCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit

protocol CertificationCoordinatorContext: BaseCoordinatorContext {
    func firstStartCertification(prsent: UINavigationController)
    func nextCertification(type: Certification)
}


extension CertificationCoordinatorContext {
    func firstStartCertification(prsent: UINavigationController) {
        let coordinator = CertificationCoordinator(present: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func nextCertification(type: Certification) {
        let coordinator = CertificationCoordinator(present: presenter, type: type)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
