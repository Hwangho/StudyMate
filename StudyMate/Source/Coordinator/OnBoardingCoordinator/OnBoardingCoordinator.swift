//
//  OnBoardingCoordinator.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit


class OnBoardingCoordinator: Coordinator {
    
    var delegate: CoordinatorDidFinishDelegate?
    
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    
    /// initialziation
    init(present: UINavigationController = UINavigationController()) {
        self.childCoordinators = []
        self.presenter = present
    }
    
    
    /// Custom Func
    func start(animated: Bool = true) {
        let viewcontroller = OnBoardingViewController()
        viewcontroller.coordinator = self
        viewcontroller.coordinatorDelegate = self
        presenter.pushViewController(viewcontroller, animated: animated)
    }
    
}


// MARK: - App
extension OnBoardingCoordinator : AppCoordinatorContext { }
