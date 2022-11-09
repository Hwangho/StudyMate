//
//  CertificationCoordinator.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit


class CertificationCoordinator: Coordinator {
    
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
        let viewcontroller = CertificationViewController(type: .inputphoneNumber)
        viewcontroller.coordinator = self
        viewcontroller.coordinatorDelegate = self
        presenter.pushViewController(viewcontroller, animated: animated)
    }
    
}
