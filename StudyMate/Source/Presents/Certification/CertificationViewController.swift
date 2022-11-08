//
//  CertificationViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit


class CertificationViewController: BaseViewController {
    
    var coordinator: CertificationCoordinator?
    
    
    /// Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        view.backgroundColor = UIColor.yellow
    }
}
