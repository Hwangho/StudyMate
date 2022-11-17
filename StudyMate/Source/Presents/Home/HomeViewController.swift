//
//  HomeViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit


final class HomeViewController: BaseViewController {
    
    var coordinator: HomeCoordinator?
    
    override func setupAttributes() {
        super.setupAttributes()
        view.backgroundColor = Color.BaseColor.green
    }
    
}
