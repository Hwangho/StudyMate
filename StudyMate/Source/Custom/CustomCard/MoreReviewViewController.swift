//
//  MoreReviewViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/21.
//

import UIKit


class MoreReviewViewController: BaseViewController {
    
    weak var coordinator: MoreReviewViewCoordinator?
    
    override func setupAttributes() {
        super.setupAttributes()
        view.backgroundColor = Color.BaseColor.green
    }
    
}


class MoreReviewViewCoordinator: Coordinator {
    var delegate: CoordinatorDidFinishDelegate?
    
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    init(presenter: UINavigationController = UINavigationController()) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start(animated: Bool = true) {
        let viewController = MoreReviewViewController()
        viewController.coordinator = self
        viewController.coordinatorDelegate = self
        presenter.pushViewController(viewController, animated: animated)
    }

}


protocol MoreReviewViewCoordinatorContext: BaseCoordinatorContext {
    func startMoreReview()
}

extension MoreReviewViewCoordinatorContext {
    func startMoreReview() {
        let coordinator = MoreReviewViewCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
