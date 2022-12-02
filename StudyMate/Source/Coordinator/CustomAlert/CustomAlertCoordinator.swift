//
//  CustomAlertCoordinator.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/21.
//

import UIKit


class CustomAlertCoordinator: Coordinator {
    
    var delegate: CoordinatorDidFinishDelegate?
    
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    
    init(present: UINavigationController = UINavigationController()) {
        self.presenter = present
        self.childCoordinators = []
    }
    
    func start(animated: Bool = true) {
        let viewController = CustomAlertViewController()
        viewController.coordinator = self
        viewController.coordinatorDelegate = self
        viewController.modalPresentationStyle = .overFullScreen
        self.presenter.present(viewController, animated: animated)
    }
    
}
