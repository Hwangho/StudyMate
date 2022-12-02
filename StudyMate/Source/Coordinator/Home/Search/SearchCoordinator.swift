//
//  SearchCoordinator.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/25.
//

import UIKit


class SearchCoordinator: Coordinator {
    
    var delegate: CoordinatorDidFinishDelegate?
    
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]

    

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start(animated: Bool = true) {
        let viewcontroller = SearchViewController()
        viewcontroller.coordinator = self
        viewcontroller.coordinatorDelegate = self
        viewcontroller.hidesBottomBarWhenPushed = true
        presenter.pushViewController(viewcontroller, animated: animated)
    }
    
    func gotoLookup(lat: Double, lng: Double) {
        let viewcontroller = SearchViewController()
        viewcontroller.coordinator = self
        viewcontroller.coordinatorDelegate = self
        viewcontroller.hidesBottomBarWhenPushed = true
        presenter.pushViewController(viewcontroller, animated: false)
        startLookupStudyfromMap(lat: lat, lng: lng)
    }
}


// MARK: - Lookup Study
extension SearchCoordinator: LookupStudyCoordinatorContext { }
