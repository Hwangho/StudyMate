//
//  CustomAlertCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/21.
//

import Foundation


protocol CustomAlertCoordinatorContext: BaseCoordinatorContext {
    func presentCustomAlert(title: String, content: String, confirmButtonTitle: String, cancelButtonTitle: String)
}

extension CustomAlertCoordinatorContext {
    func presentCustomAlert(title: String, content: String, confirmButtonTitle: String = "확인", cancelButtonTitle: String = "취소") {
        let coordinator = CustomAlertCoordinator(present: presenter, title: title, content: content, confirmButtonTitle: confirmButtonTitle, cancelButtonTitle: cancelButtonTitle)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}


