//
//  ChangeMyPageCoordinator.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/17.
//

import UIKit


class ChangeMyPageCoordinator: Coordinator {
    
    var delegate: CoordinatorDidFinishDelegate?
    
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start(animated: Bool = true) {
        let viewController = ChangeMyPageViewController()
        viewController.coordinator = self
        viewController.coordinatorDelegate = self
        viewController.hidesBottomBarWhenPushed = true
        presenter.pushViewController(viewController, animated: true)
    }
}


// MARK: - MoreReviewView
extension ChangeMyPageCoordinator: MoreReviewViewCoordinatorContext { }


// MARK: - appCoordinatorContext
extension ChangeMyPageCoordinator: AppCoordinatorContext { }



extension ChangeMyPageCoordinator: CustomAlertCoordinatorContext {
    func presentCustomAlert() {
        let coordinator = CustomAlertCoordinator(present: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
