//
//  MyPageCoordinator.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/17.
//

import UIKit


class MyPageCoordinator: Coordinator {
    
    var delegate: CoordinatorDidFinishDelegate?
    
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start(animated: Bool = true) {
        let viewController = MyPageViewController()
        viewController.coordinator = self
        viewController.coordinatorDelegate = self
        presenter.pushViewController(viewController, animated: true)
    }
    
    
}


// MARK: - ChangeMyPage
extension MyPageCoordinator: ChangeMyPageCoordinatorContext { }
