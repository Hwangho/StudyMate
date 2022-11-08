//
//  Coordinator.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/07.
//

import UIKit


// coordinator 해제를 하기 위한 프로토콜
protocol CoordinatorDidFinishDelegate: AnyObject {
    
    // viewController 해제시 호출함
    func didFinishCoordinator()
    
    // parent coordinator에서 child coordinator 제거
    func removeChild(coordinator: Coordinator)
}


protocol Coordinator: CoordinatorDidFinishDelegate {
    
    var delegate: CoordinatorDidFinishDelegate? { get set }
    
    var presenter: UINavigationController { get set }

    var childCoordinators: [Coordinator] { get set }
    
    // 컨트롤러 생성 및 화면 전환
    func start(animated: Bool)

}


extension Coordinator {
    var className: String {
        let typeString = String(describing: type(of: self))
        return typeString.components(separatedBy: ".").last ?? ""
    }
    
    func didFinishCoordinator() {
        delegate?.removeChild(coordinator: self)
    }
    
    func removeChild(coordinator: Coordinator) {
        for (index, child) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                dump("🧡🧡 REMOVE COORDINATOR: \(coordinator.className) 🧡🧡")
                break
            }
        }
    }

}
