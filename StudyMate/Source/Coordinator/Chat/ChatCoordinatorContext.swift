//
//  ChatCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/12/05.
//

import UIKit


protocol ChatCoordinatorContext: BaseCoordinatorContext {
    func startChat()
}


extension ChatCoordinatorContext {
    func startChat() {
        let coordinator = ChatCoordinator(present: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start(animated: true)
    }
}
