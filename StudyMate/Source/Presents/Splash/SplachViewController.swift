//
//  SplachViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/17.
//

import UIKit

import SnapKit
import RxSwift


class SplachViewController: BaseViewController {
    
    let mainImage = UIImageView()
    
    let titleImage = UIImageView()
    
    let viewModel = SplachviewModel()
    
    var coordinator: SplachCoordinator!
    
    
    
    override func setupAttributes() {
        super.setupAttributes()
        mainImage.contentMode = .scaleAspectFit
        mainImage.image = UIImage(named: "splash_logo")
        mainImage.alpha = 0
        
        titleImage.contentMode = .scaleAspectFit
        titleImage.image = UIImage(named: "splash_txt")
        titleImage.alpha = 0
        
        UIView.animate(withDuration: 2.0) {
            self.mainImage.alpha = 1
            self.titleImage.alpha = 1
        } completion: { finish in
            self.viewModel.action.accept(.login)
        }

    }
    
    override func setupLayout() {
        [mainImage, titleImage].forEach {
            view.addSubview($0)
        }
        
        mainImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.75)
            make.height.equalTo(mainImage.snp.width).multipliedBy(259.0/218.0)
        }
        
        titleImage.snp.makeConstraints { make in
            make.centerX.equalTo(mainImage.snp.centerX)
            make.top.equalTo(mainImage.snp.bottom).offset(35)
            make.width.equalTo(mainImage.snp.height).multipliedBy(291.0/101.0)
        }
    }
    
    override func setupBinding() {
        

        viewModel.currentStore
            .distinctUntilChanged{ $0.serverType }
            .map { $0.serverType }
            .bind { [weak self] type in
                let value: Bool? = LocalUserDefaults.shared.value(key: .onBoarding)
                
                if value == nil {
                    self?.coordinator.showInitialView(with: .onBoarding)
                }
                else {
                    guard let type = type else { return }
                    switch type {
                    case .successed:
                        self?.coordinator.showInitialView(with: .main)
                    case .FireBaseToken:
                        self?.fireBaseIDTokenRefresh()
                        self?.viewModel.action.accept(.login)
                    case .noneSignup, .clientError:
                        self?.coordinator.showInitialView(with: .certification)
                    default:
                        self?.showAlertMessage(title: type.message)
                    }
                }
                LocalUserDefaults.shared.checkUserDefualt()
            }
            .disposed(by: disposeBag)
    }
}


class SplachCoordinator: Coordinator {

    /// variable
    var window: UIWindow
    
    var delegate: CoordinatorDidFinishDelegate?
    
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    var disposeBag = DisposeBag()
    
    
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





protocol SplachCoordinatorContext: BaseCoordinatorContext {
    func showSplash(window: UIWindow)
}

extension SplachCoordinatorContext {
    func showSplash(window: UIWindow) {
        let coordinator = SplachCoordinator(window: window)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

}
