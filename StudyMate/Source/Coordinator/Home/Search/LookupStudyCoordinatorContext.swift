//
//  LookupStudyCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/28.
//

import Foundation


protocol LookupStudyCoordinatorContext: BaseCoordinatorContext {
    func startLookupStudy()
}

extension LookupStudyCoordinatorContext {
    func startLookupStudy() {
        let coordinator = LookupStudyCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

}

