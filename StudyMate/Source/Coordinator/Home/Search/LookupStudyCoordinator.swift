//
//  LookupStudyCoordinator.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/28.
//

import UIKit


class LookupStudyCoordinator: Coordinator {
    
    var delegate: CoordinatorDidFinishDelegate?
    
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    
    /// Initialization
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    
    /// Start
    func start(animated: Bool = true) {
        let viewController = LookupStudyViewController()
        viewController.coordinator = self
        viewController.coordinatorDelegate = self
        presenter.pushViewController(viewController, animated: animated)
    }
    
}


extension LookupStudyCoordinator: MoreReviewViewCoordinatorContext { }
