//
//  CertificationCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit

protocol CertificationCoordinatorContext: BaseCoordinatorContext {
    func firstStartCertification(prsent: UINavigationController)
}


extension CertificationCoordinatorContext {
    func firstStartCertification(prsent: UINavigationController) {
        let coordinator = CertificationCoordinator(present: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
