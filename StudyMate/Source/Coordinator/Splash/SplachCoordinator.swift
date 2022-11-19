//
//  SplachCoordinator.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/17.
//

import UIKit


final class SplachCoordinator: Coordinator {

    /// variable
    private var window: UIWindow
    
    var delegate: CoordinatorDidFinishDelegate?
    
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    
    /// initialziation
    init(window: UIWindow) {
        self.window = window
        self.childCoordinators = []
        self.presenter = UINavigationController()

    }
    
    func start(animated: Bool = true) {
        let viewcontroller = SplachViewController()
        viewcontroller.coordinator = self
        viewcontroller.coordinatorDelegate = self
        window.rootViewController = viewcontroller
    }
    
}

extension SplachCoordinator: AppCoordinatorContext { }

