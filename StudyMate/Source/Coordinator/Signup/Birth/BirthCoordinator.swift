//
//  BirthCoordinator.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/10.
//

import UIKit


class BirthCoordinator: Coordinator {
    
    var delegate: CoordinatorDidFinishDelegate?
    
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    
    /// initialziation
    init(present: UINavigationController = UINavigationController()) {
        self.presenter = present
        self.childCoordinators = []
    }
    
    
    /// Custom Func
    func start(animated: Bool = true) {
        let viewcontroller = BirthViewController()
        viewcontroller.coordinator = self
        viewcontroller.coordinatorDelegate = self
        presenter.pushViewController(viewcontroller, animated: animated)
    }
    
}


// MARK: - Birth
extension BirthCoordinator: EmailCoordinatorContext { }
