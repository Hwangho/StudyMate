//
//  MyPageCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/17.
//

import UIKit

protocol MyPageCoordinatorContext: BaseCoordinatorContext {
    func startMyPage(prsenter: UINavigationController)
}

extension MyPageCoordinatorContext {
    func startMyPage(prsenter: UINavigationController) {
        let coordinator = MyPageCoordinator(presenter: prsenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
