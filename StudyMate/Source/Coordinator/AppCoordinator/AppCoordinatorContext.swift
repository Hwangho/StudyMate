//
//  AppCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit


protocol AppCoordinatorContext: BaseCoordinatorContext {
    func showInitialView(with type: AppCoordinator.InitalViewType)
}

extension AppCoordinatorContext {
    func showInitialView(with type: AppCoordinator.InitalViewType) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        sceneDelegate?.appCoordinator.showInitialView(with: type)
    }
}
