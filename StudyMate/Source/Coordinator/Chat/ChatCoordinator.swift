//
//  ChatCoordinator.swift
//  StudyMate
//
//  Created by 송황호 on 2022/12/05.
//

import UIKit


class ChatCoordinator: Coordinator {
    
    var delegate: CoordinatorDidFinishDelegate?
    
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    init(present: UINavigationController) {
        self.presenter = present
        self.childCoordinators = []
    }
    
    func start(animated: Bool) {
        let viewcontroller = ChatViewController()
        viewcontroller.coordinator = self
        viewcontroller.coordinatorDelegate = self
        presenter.pushViewController(viewcontroller, animated: animated)
    }
    
}
