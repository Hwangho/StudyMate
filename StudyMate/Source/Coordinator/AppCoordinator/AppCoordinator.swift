//
//  AppCoordinator.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/07.
//

import UIKit


class AppCoordinator: Coordinator {
    
    enum InitalViewType {
        case onBoarding
        case certification
        case main
    }
    
    
    /// variable
    var window: UIWindow
    
    var delegate: CoordinatorDidFinishDelegate?
    
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    var tabbar: TabbarViewController
    
    
    /// initialziation
    init(window: UIWindow) {
        self.window = window
        self.childCoordinators = []
        self.presenter = UINavigationController()
        self .tabbar = TabbarViewController()
    }
    
    func start(animated: Bool = true) {
//        var type: InitalViewType = UserDefaults.standard.bool(forKey: "checkEnterboarding") ? .onBoarding: .certification
        
        let type: InitalViewType = .certification
        showInitialView(with: type)
    }
    
    
    /// Custom Func
    func showInitialView(with type: InitalViewType) {
        switch type {
        case .onBoarding:
            presenter = UINavigationController()
            firstStartOnBoarding(present: presenter)
            self.window.rootViewController = presenter
            
        case .certification:
            presenter = UINavigationController()
            firstStartCertification(prsent: presenter)
            self.window.rootViewController = presenter
            
        case .main:
            firstStartMain(tabbar: tabbar)
            self.window.rootViewController = tabbar
        }
        
        self.window.makeKeyAndVisible()
        
        UIView.transition(with: self.window,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
}


// MARK: - OnBoarding
extension AppCoordinator: OnBoardingCoordinatorContext { }


// MARK: - Certification
extension AppCoordinator: CertificationCoordinatorContext { }


// MARK: - Mian
extension AppCoordinator: MainCoordinatorContext { }
