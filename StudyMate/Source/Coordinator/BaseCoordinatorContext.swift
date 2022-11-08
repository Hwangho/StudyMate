//
//  BaseCoordinatorContext.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit


protocol BaseCoordinatorContext: CoordinatorDidFinishDelegate {
    var delegate: CoordinatorDidFinishDelegate? { get set }
    
    var presenter: UINavigationController { get set }
    
    var childCoordinators: [Coordinator] { get set }
    
    func start(animated: Bool)
}
