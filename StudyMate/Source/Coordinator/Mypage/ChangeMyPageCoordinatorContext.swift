//
//  ChangeMyPageCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/17.
//

import UIKit

protocol ChangeMyPageCoordinatorContext: BaseCoordinatorContext {
    func startChangeMyPage()
}

extension ChangeMyPageCoordinatorContext {
    func startChangeMyPage() {
        let coordinator = ChangeMyPageCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
