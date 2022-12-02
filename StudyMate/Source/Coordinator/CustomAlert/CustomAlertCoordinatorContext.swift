//
//  CustomAlertCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/21.
//

import Foundation


protocol CustomAlertCoordinatorContext: BaseCoordinatorContext {
    func presentCustomAlert()
}

extension CustomAlertCoordinatorContext {
    func presentCustomAlert() {
        let coordinator = CustomAlertCoordinator(present: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}


