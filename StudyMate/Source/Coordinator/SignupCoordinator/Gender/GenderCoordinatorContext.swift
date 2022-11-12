//
//  GenderCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/10.
//

import UIKit

protocol GenderCoordinatorContext: BaseCoordinatorContext {
    func startGender()
}


extension GenderCoordinatorContext {
    func startGender() {
        let coordinator = GenderCoordinator(present: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

