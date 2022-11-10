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
    
    let type: Certification
    
    
    /// initialziation
    init(present: UINavigationController = UINavigationController(), type: Certification = .phoneNumber) {
        self.presenter = present
        self.type = type
        self.childCoordinators = []
    }
    
    
    /// Custom Func
    func start(animated: Bool = true) {
        let viewcontroller = CertificationViewController(type: type)
        viewcontroller.coordinator = self
        viewcontroller.coordinatorDelegate = self
        presenter.pushViewController(viewcontroller, animated: animated)
    }
    
}


extension CertificationCoordinator: CertificationCoordinatorContext { }
