//
//  TabbarViewController.swift
//  StudyMate
//
//  Created by 송황호 on 2022/11/08.
//

import UIKit


class TabbarViewController: UITabBarController {
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Custom Func
    private func setupAttributes() {
        view.backgroundColor = Color.BaseColor.white
        
        tabBar.backgroundColor = UIColor.white
        tabBar.tintColor = Color.BaseColor.green
        tabBar.unselectedItemTintColor = Color.BaseColor.gray6
        tabBar.isHidden = false
    }
    
    func configure(with tabControllers: [UIViewController]) {
//        delegate = self
        setViewControllers(tabControllers, animated: true)
        selectedIndex = 0
        tabBar.isTranslucent = false
    }
    
}


