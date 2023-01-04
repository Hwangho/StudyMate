//
//  LookupStudyCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/28.
//

import Foundation


protocol LookupStudyCoordinatorContext: BaseCoordinatorContext {
    func startLookupStudy()
    func startLookupStudyfromMap(lat: Double, lng: Double)
}

extension LookupStudyCoordinatorContext {
    func startLookupStudy() {
        let coordinator = LookupStudyCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func startLookupStudyfromMap(lat: Double, lng: Double) {
        let coordinator = LookupStudyCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.homepushStart(lat: lat, lng: lng)
    }
}

