//
//  LookupStudyCoordinator.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/28.
//

import UIKit


class LookupStudyCoordinator: Coordinator {
    
    var delegate: CoordinatorDidFinishDelegate?
    
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    
    /// Initialization
    init(presenter: UINavigationController, lat: Double = 0, lng: Double = 0) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    
    /// Start
    func start(animated: Bool = true) {
        let viewController = LookupStudyViewController(lat: nil, lng: nil)
        viewController.coordinator = self
        viewController.coordinatorDelegate = self
        presenter.pushViewController(viewController, animated: animated)
    }
    
    func homepushStart(animated: Bool = true, lat: Double, lng: Double) {
        let viewController = LookupStudyViewController(lat: lat, lng: lng)
        viewController.coordinator = self
        viewController.coordinatorDelegate = self
        presenter.pushViewController(viewController, animated: animated)
    }
    
    func popandgoMap() {
        presenter.popToRootViewController(animated: true)
    }
    
    func popandgoChat() {
        presenter.popToRootViewController(animated: true)
        startChat()
    }
    
    func popLookupStudy() {
        presenter.popViewController(animated: true)
    }
}


// MARK: - Review
extension LookupStudyCoordinator: MoreReviewViewCoordinatorContext { }


// MARK: - Chat
extension LookupStudyCoordinator: ChatCoordinatorContext { }
