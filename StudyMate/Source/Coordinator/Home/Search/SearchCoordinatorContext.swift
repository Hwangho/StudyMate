//
//  SearchCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/25.
//

import Foundation


protocol SearchCoordinatorContext: BaseCoordinatorContext {
    func startSearch()
    func pushtoLookupStudy(lat: Double, lng: Double)
}

extension SearchCoordinatorContext {
    func startSearch() {
        let coordinator = SearchCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func pushtoLookupStudy(lat: Double, lng: Double) {
        let coordinator = SearchCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.gotoLookup(lat: lat, lng: lng)
    }
}
