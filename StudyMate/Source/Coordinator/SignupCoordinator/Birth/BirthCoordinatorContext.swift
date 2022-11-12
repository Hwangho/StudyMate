//
//  BirthCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/10.
//

import Foundation


protocol BirthCoordinatorContext: BaseCoordinatorContext {
    func startBirth()
}


extension BirthCoordinatorContext {
    func startBirth() {
        let coordinator = BirthCoordinator(present: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
