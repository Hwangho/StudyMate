//
//  EmailCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/10.
//

import UIKit

protocol EmailCoordinatorContext: BaseCoordinatorContext {
    func startEmail()
}


extension EmailCoordinatorContext {
    func startEmail() {
        let coordinator = EmailCoordinator(present: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
