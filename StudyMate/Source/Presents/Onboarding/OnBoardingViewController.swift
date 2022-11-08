//
//  OnBoardingViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit


class OnBoardingViewController: BaseViewController {
    
    
    /// variable
    var coordinator: OnBoardingCoordinator?
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        view.backgroundColor = UIColor.red
    }
    
}
