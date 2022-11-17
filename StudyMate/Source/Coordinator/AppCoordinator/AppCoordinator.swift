//
//  AppCoordinator.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/07.
//

import UIKit

import RxSwift


final class AppCoordinator: Coordinator {
    
    enum InitalViewType {
        case splash
        case onBoarding
        case certification
        case main
    }
    
    
    /// variable
    private var window: UIWindow
    
    var delegate: CoordinatorDidFinishDelegate?
    
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    private var tabbar: TabbarViewController
    
    private var service: UserServiceProtocool
    
    
    /// initialziation
    init(window: UIWindow) {
        self.window = window
        self.childCoordinators = []
        self.presenter = UINavigationController()
        self.tabbar = TabbarViewController()
        self.service = UserService()
    }
    
    func start(animated: Bool = true) {
        showInitialView(with: .splash)
    }
    
    
    /// Custom Func
    func showInitialView(with type: InitalViewType) {
        switch type {
        case .splash:
            showSplash(window: window)
            
        case .onBoarding:
            presenter = UINavigationController()
            firstStartOnBoarding(present: presenter)
            self.window.rootViewController = presenter
            
        case .certification:
            presenter = UINavigationController()
            
            let value: String? = LocalUserDefaults.shared.value(key: .FirebaseidToken)
            if value == nil {
                firstStartCertification(prsent: presenter)
            } else {
                firstStartNickName(present: presenter)
            }
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


// MARK: - Splash
extension AppCoordinator: SplachCoordinatorContext { }


// MARK: - OnBoarding
extension AppCoordinator: OnBoardingCoordinatorContext { }


// MARK: - Certification
extension AppCoordinator: CertificationCoordinatorContext { }


// MARK: - Mian
extension AppCoordinator: MainCoordinatorContext { }


// MARK: - NickName
extension AppCoordinator: NickNameCoordinatorContext { }

