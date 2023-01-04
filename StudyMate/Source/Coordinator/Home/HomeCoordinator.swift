//
//  HomeCoordinator.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit


class HomeCoordinator: Coordinator {
    
    var delegate: CoordinatorDidFinishDelegate?
    
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        childCoordinators = []
    }
    
    func start(animated: Bool = true) {
        let viewController = HomeViewController()
        viewController.coordinator = self
        viewController.coordinatorDelegate = self
        presenter.pushViewController(viewController, animated: true)
    }
    
}


// MARK: - Search 화면
extension HomeCoordinator: SearchCoordinatorContext { }


// MARK: - Chat
extension HomeCoordinator: ChatCoordinatorContext { }
