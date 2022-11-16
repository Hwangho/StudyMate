//
//  AppCoordinator.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/07.
//

import UIKit

import RxSwift


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
    
    var service: UserServiceProtocool
    
    var disposeBag = DisposeBag()
    
    
    /// initialziation
    init(window: UIWindow) {
        self.window = window
        self.childCoordinators = []
        self.presenter = UINavigationController()
        self.tabbar = TabbarViewController()
        self.service = UserService()
    }
    
    func start(animated: Bool = true) {
        let value: Bool? = LocalUserDefaults.shared.value(key: .onBoarding)
        
        let type: InitalViewType = value == nil ? .onBoarding : .certification
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
            
            let value: String? = LocalUserDefaults.shared.value(key: .FirebaseidToken)
            if value == nil {
                firstStartCertification(prsent: presenter)
            } else {
                firstStartNickName(present: presenter)
            }
//            firstStartNickName(present: presenter)
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


// MARK: - Birth
extension AppCoordinator: BirthCoordinatorContext {}


// MARK: - Certification
extension AppCoordinator: CertificationCoordinatorContext { }


// MARK: - Mian
extension AppCoordinator: MainCoordinatorContext { }


// MARK: - NickName
extension AppCoordinator: NickNameCoordinatorContext { }







extension AppCoordinator: GenderCoordinatorContext {}
