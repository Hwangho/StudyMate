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
    
    let title: String
    
    let content: String
    
    let confirmButtonTitle: String
    
    let cancelButtonTitle: String
    
    
    init(present: UINavigationController = UINavigationController(), title: String, content: String, confirmButtonTitle: String, cancelButtonTitle: String) {
        self.presenter = present
        self.childCoordinators = []
        self.title = title
        self.content = content
        self.confirmButtonTitle = confirmButtonTitle
        self.cancelButtonTitle = cancelButtonTitle
    }
    
    func start(animated: Bool = true) {
        let viewController = CustomAlertViewController(alertTitleText: title, alertContentText: content, cancelButtonText: cancelButtonTitle, confirmButtonText: confirmButtonTitle)
        viewController.coordinator = self
        viewController.coordinatorDelegate = self
        viewController.modalPresentationStyle = .overFullScreen
        self.presenter.present(viewController, animated: animated)
    }
    
}
